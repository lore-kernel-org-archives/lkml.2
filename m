Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750817Ab1JIE0S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Oct 2011 00:26:18 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:57825 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750732Ab1JIE0Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Oct 2011 00:26:16 -0400
MIME-Version: 1.0
In-Reply-To: <1318075505.4933.3.camel@localhost>
References: <1317397918.27140.15.camel@localhost>
	<x49pqieyw2f.fsf@segfault.boston.devel.redhat.com>
	<1317729761.25998.4.camel@localhost>
	<x49bottoq57.fsf@segfault.boston.devel.redhat.com>
	<CANejiEXnXJ7LkyqHyH1S2c4A95Si7v0-gDmRD824r3ROntaDCA@mail.gmail.com>
	<1318075505.4933.3.camel@localhost>
Date: Sun, 9 Oct 2011 12:26:15 +0800
X-Google-Sender-Auth: 20riD_w2yvEigFqAVlpInMM_Sfo
Message-ID: <CANejiEV385RwOHVKnf5cP3zjr7AOUg9gwAxQkpS3n_LEKCoAtg@mail.gmail.com>
Subject: Re: [dm-devel] Block regression since 3.1-rc3
From: Shaohua Li <shli@kernel.org>
To: Christophe Saout <christophe@saout.de>
Cc: Jeff Moyer <jmoyer@redhat.com>,
        device-mapper development <dm-devel@redhat.com>,
        linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Tejun Heo <tj@kernel.org>
Content-Type: multipart/mixed; boundary=0016e64fcb7836ce7204aed613cc
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0016e64fcb7836ce7204aed613cc
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

2011/10/8 Christophe Saout <christophe@saout.de>:
> Hi Shaohua,
>
>> >> Line 323 is this one: BUG_ON(!rq->bio || rq->bio !=3D rq->biotail);
>> >
>> > OK, it turns out my testing was incomplete. =A0I only tested targets t=
hat
>> > had a write-through cache, so I didn't hit this problem. =A0It reprodu=
ces
>> > pretty easily with just multipath involved (no linear target on top) w=
hen
>> > running against the right storage.
>> >
>> > So, here's a patch, but I don't have a full explanation for it just ye=
t.
>> > What I observed was that, on fsync, blkdev_issue_flush was called.
>> > Eventually, the flush request gets cloned, and blk_insert_cloned_reque=
st
>> > is called. =A0This cloned request never actually gets issued to the
>> > q->requst_fn (scsi_request_fn in my case). =A0So, it may be that there=
 is
>> > no plug list for this, so the queue isn't goosed? =A0I'll try to come =
up
>> > with a better explanation, or Tejun may just know off the top of his
>> > head what's going on.
>> >
>> > So, the patch works for me, but is very much just an RFC.
>> [...]
>> Looks the dm request based flush logic is broken.
>>
>> saved_make_request_fn
>> =A0 __make_request
>> =A0 =A0 blk_insert_flush
>> but blk_insert_flush doesn't put the original request to list, instead, =
the
>> q->flush_rq is in list.
>> then
>> dm_request_fn
>> =A0 blk_peek_request
>> =A0 =A0 dm_prep_fn
>> =A0 =A0 =A0 clone_rq
>> =A0 map_request
>> =A0 =A0 blk_insert_cloned_request
>> so q->flush_rq is cloned, and get dispatched. but we can't clone q->flus=
h_rq
>> and use it to do flush. map_request even could assign a different blockd=
ev to
>> the cloned request.
>>
>> Clone q->flush_rq is absolutely wrong. we can clear ogirinal request's f=
lush bit
>> and set cloned request flush bit, so we can skip the blk_insert_flush lo=
gic for
>> original request.
>>
>> can you please try this patch. Only compilation tested.
>
> Now I get a different BUG when doing what triggered the original BUG
> (e.g. unmounting the filesystem):
>
> ------------[ cut here ]------------
> kernel BUG at drivers/scsi/scsi_lib.c:1152!
> invalid opcode: 0000 [#1] PREEMPT SMP
> CPU 7
> Modules linked in: xenfs gfs2 fuse dlm configfs dummy bonding xt_TPROXY n=
f_tproxy_core xt_socket xt_owner xt_connmark iptable_mangle ipt_MASQUERADE =
iptable_nat ipt_ULOG ipt_REJECT xt_mark iptable_filter iptable_raw ip_table=
s ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_state xt_tcpudp xt_physde=
v xt_hashlimit xt_multiport ip6table_filter ip6_tables ebt_redirect ebt_ip =
ebt_mark_m ebtable_broute bridge stp llc ebtable_nat ext4 jbd2 dm_round_rob=
in dm_multipath ebtable_filter ebtables x_tables nf_nat_tftp nf_conntrack_t=
ftp nf_nat_sip nf_conntrack_sip nf_nat_irc nf_conntrack_irc nf_nat_h323 nf_=
conntrack_h323 nf_nat_ftp nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_conntr=
ack_ftp nf_conntrack xen_netback xen_blkback xen_gntdev ipmi_si ipmi_devint=
f ipmi_msghandler loop ohci_hcd ehci_hcd e1000e tpm_tis igb qla2xxx tpm tpm=
_bios scsi_transport_fc pata_atiixp i2c_piix4
>
> Pid: 5056, comm: kworker/7:2 Not tainted 3.1.0-rc8 #1 Supermicro H8DG6/H8=
DGi/H8DG6/H8DGi
> RIP: e030:[<ffffffff812f7eae>] =A0[<ffffffff812f7eae>] scsi_setup_fs_cmnd=
+0x9e/0xe0
> RSP: e02b:ffff88009b299b70 =A0EFLAGS: 00010046
> RAX: 0000000000000000 RBX: ffff88009b9cc018 RCX: 0000000000000000
> RDX: ffff88009f193c00 RSI: ffff88009b9cc018 RDI: ffff88009b905800
> RBP: ffff88009b299b80 R08: 0000000000000000 R09: 0000000000000001
> R10: 0000000000000001 R11: ffff8800a0e40700 R12: ffff88009b905800
> R13: 0000000000000001 R14: ffff88009b905800 R15: 0000000000000000
> FS: =A000007fc76ab77700(0000) GS:ffff8800d767f000(0000) knlGS:00000000000=
00000
> CS: =A0e033 DS: 0000 ES: 0000 CR0: 000000008005003b
> CR2: 00007fc76a1d0beb CR3: 0000000001805000 CR4: 0000000000000660
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process kworker/7:2 (pid: 5056, threadinfo ffff88009b298000, task ffff880=
09ed68000)
> Stack:
> =A0ffff88009b9cc018 ffff88009e5f1a60 ffff88009b299bf0 ffffffff8130675f
> =A0ffff88009b299ba0 ffffffff810ceef0 ffff88009f193c00 ffffffff00000000
> =A0ffffffff8100ab6d ffff88009b299c60 ffff88009ed68000 ffff88009b9cc018
> Call Trace:
> =A0[<ffffffff8130675f>] sd_prep_fn+0x14f/0xa70
> =A0[<ffffffff810ceef0>] ? mempool_alloc_slab+0x10/0x20
> =A0[<ffffffff8100ab6d>] ? xen_force_evtchn_callback+0xd/0x10
> =A0[<ffffffff81215db2>] blk_peek_request+0xd2/0x270
> =A0[<ffffffff812f8aeb>] scsi_request_fn+0x4b/0x3c0
> =A0[<ffffffff8120fa46>] __blk_run_queue+0x16/0x20
> =A0[<ffffffff8120ef03>] __elv_add_request+0xb3/0x270
> =A0[<ffffffff81213494>] add_acct_request+0x34/0x40
> =A0[<ffffffff8121350b>] blk_insert_cloned_request+0x6b/0x90
> =A0[<ffffffff8138c049>] dm_dispatch_request+0x39/0x70
> =A0[<ffffffff8138db9c>] dm_request_fn+0x17c/0x280
> =A0[<ffffffff8100b322>] ? check_events+0x12/0x20
> =A0[<ffffffff81222db0>] ? cfq_init_queue+0x430/0x430
> =A0[<ffffffff8120fa46>] __blk_run_queue+0x16/0x20
> =A0[<ffffffff81222de4>] cfq_kick_queue+0x34/0x50
> =A0[<ffffffff8106e039>] process_one_work+0x129/0x4a0
> =A0[<ffffffff81070401>] worker_thread+0x161/0x340
> =A0[<ffffffff810702a0>] ? manage_workers.clone.22+0x230/0x230
> =A0[<ffffffff81074d36>] kthread+0x96/0xa0
> =A0[<ffffffff814cb7b4>] kernel_thread_helper+0x4/0x10
> =A0[<ffffffff814c9873>] ? int_ret_from_sys_call+0x7/0x1b
> =A0[<ffffffff814c2dc0>] ? retint_restore_args+0x5/0x6
> =A0[<ffffffff814cb7b0>] ? gs_change+0x13/0x13
> Code: ff 5b 41 5c c9 c3 0f 1f 80 00 00 00 00 4c 89 e7 be 20 00 00 00 e8 a=
3 a2 ff ff 48 85 c0 48 89 c7 74 36 48 89 83 e0 00 00 00 eb 9b <0f> 0b 48 8b=
 00 48 85 c0 0f 84 77 ff ff ff 48 8b 40 50 48 85 c0
> RIP =A0[<ffffffff812f7eae>] scsi_setup_fs_cmnd+0x9e/0xe0
> =A0RSP <ffff88009b299b70>
> ---[ end trace 35f29bc1fdb897a6 ]---
> note: kworker/7:2[5056] exited with preempt_count 1
>
> (followed by an oops and the machine is dead in an instant)
>
there is a typo there, please check the new one.

--0016e64fcb7836ce7204aed613cc
Content-Type: text/x-patch; charset=US-ASCII; name="block-cloned-request-flush.patch"
Content-Disposition: attachment; filename="block-cloned-request-flush.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gtjjdb040

U2lnbmVkLW9mZi1ieTogU2hhb2h1YSBMaSA8c2hhb2h1YS5saUBpbnRlbC5jb20+CgpkaWZmIC0t
Z2l0IGEvZHJpdmVycy9tZC9kbS5jIGIvZHJpdmVycy9tZC9kbS5jCmluZGV4IDUyYjM5ZjMuLjA3
YTkzMGQgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvbWQvZG0uYworKysgYi9kcml2ZXJzL21kL2RtLmMK
QEAgLTE0MjQsNiArMTQyNCwxMyBAQCBzdGF0aWMgaW50IGRtX21ha2VfcmVxdWVzdChzdHJ1Y3Qg
cmVxdWVzdF9xdWV1ZSAqcSwgc3RydWN0IGJpbyAqYmlvKQogewogCXN0cnVjdCBtYXBwZWRfZGV2
aWNlICptZCA9IHEtPnF1ZXVlZGF0YTsKIAorCWlmIChiaW8tPmJpX3J3ICYgKFJFUV9GTFVTSCB8
IFJFUV9GVUEpKSB7CisJCWlmIChiaW8tPmJpX3J3ICYgUkVRX0ZMVVNIKQorCQkJYmlvLT5iaV9y
dyB8PSBSRVFfQ0xPTkVEX0ZMVVNIOworCQlpZiAoYmlvLT5iaV9ydyAmIFJFUV9GVUEpCisJCQli
aW8tPmJpX3J3IHw9IFJFUV9DTE9ORURfRlVBOworCQliaW8tPmJpX3J3ICY9IH4oUkVRX0ZMVVNI
fFJFUV9GVUEpOworCX0KIAlyZXR1cm4gbWQtPnNhdmVkX21ha2VfcmVxdWVzdF9mbihxLCBiaW8p
OyAvKiBjYWxsIF9fbWFrZV9yZXF1ZXN0KCkgKi8KIH0KIApAQCAtMTU0Nyw2ICsxNTU0LDE0IEBA
IHN0YXRpYyBpbnQgZG1fcHJlcF9mbihzdHJ1Y3QgcmVxdWVzdF9xdWV1ZSAqcSwgc3RydWN0IHJl
cXVlc3QgKnJxKQogCWlmICghY2xvbmUpCiAJCXJldHVybiBCTEtQUkVQX0RFRkVSOwogCisJaWYg
KHJxLT5jbWRfZmxhZ3MgJiBSRVFfQ0xPTkVEX0ZMVVNIKQorCQljbG9uZS0+Y21kX2ZsYWdzIHw9
IFJFUV9GTFVTSDsKKwlpZiAocnEtPmNtZF9mbGFncyAmIFJFUV9DTE9ORURfRlVBKQorCQljbG9u
ZS0+Y21kX2ZsYWdzIHw9IFJFUV9GVUE7CisKKwlycS0+Y21kX2ZsYWdzICY9ICB+KFJFUV9DTE9O
RURfRkxVU0h8UkVRX0NMT05FRF9GVUEpOworCWNsb25lLT5jbWRfZmxhZ3MgJj0gIH4oUkVRX0NM
T05FRF9GTFVTSHxSRVFfQ0xPTkVEX0ZVQSk7CisKIAlycS0+c3BlY2lhbCA9IGNsb25lOwogCXJx
LT5jbWRfZmxhZ3MgfD0gUkVRX0RPTlRQUkVQOwogCmRpZmYgLS1naXQgYS9pbmNsdWRlL2xpbnV4
L2Jsa190eXBlcy5oIGIvaW5jbHVkZS9saW51eC9ibGtfdHlwZXMuaAppbmRleCA3MWZjNTNiLi42
ZWY1ZGMzIDEwMDY0NAotLS0gYS9pbmNsdWRlL2xpbnV4L2Jsa190eXBlcy5oCisrKyBiL2luY2x1
ZGUvbGludXgvYmxrX3R5cGVzLmgKQEAgLTE1Myw2ICsxNTMsOCBAQCBlbnVtIHJxX2ZsYWdfYml0
cyB7CiAJX19SRVFfRkxVU0hfU0VRLAkvKiByZXF1ZXN0IGZvciBmbHVzaCBzZXF1ZW5jZSAqLwog
CV9fUkVRX0lPX1NUQVQsCQkvKiBhY2NvdW50IEkvTyBzdGF0ICovCiAJX19SRVFfTUlYRURfTUVS
R0UsCS8qIG1lcmdlIG9mIGRpZmZlcmVudCB0eXBlcywgZmFpbCBzZXBhcmF0ZWx5ICovCisJX19S
RVFfQ0xPTkVEX0ZMVVNILAorCV9fUkVRX0NMT05FRF9GVUEsCiAJX19SRVFfTlJfQklUUywJCS8q
IHN0b3BzIGhlcmUgKi8KIH07CiAKQEAgLTE3MCw3ICsxNzIsNyBAQCBlbnVtIHJxX2ZsYWdfYml0
cyB7CiAJKFJFUV9GQUlMRkFTVF9ERVYgfCBSRVFfRkFJTEZBU1RfVFJBTlNQT1JUIHwgUkVRX0ZB
SUxGQVNUX0RSSVZFUikKICNkZWZpbmUgUkVRX0NPTU1PTl9NQVNLIFwKIAkoUkVRX1dSSVRFIHwg
UkVRX0ZBSUxGQVNUX01BU0sgfCBSRVFfU1lOQyB8IFJFUV9NRVRBIHwgUkVRX1BSSU8gfCBcCi0J
IFJFUV9ESVNDQVJEIHwgUkVRX05PSURMRSB8IFJFUV9GTFVTSCB8IFJFUV9GVUEgfCBSRVFfU0VD
VVJFKQorCSBSRVFfRElTQ0FSRCB8IFJFUV9OT0lETEUgfCBSRVFfRkxVU0ggfCBSRVFfRlVBIHwg
UkVRX1NFQ1VSRSB8IFJFUV9DTE9ORURfRkxVU0ggfCBSRVFfQ0xPTkVEX0ZVQSkKICNkZWZpbmUg
UkVRX0NMT05FX01BU0sJCVJFUV9DT01NT05fTUFTSwogCiAjZGVmaW5lIFJFUV9SQUhFQUQJCSgx
IDw8IF9fUkVRX1JBSEVBRCkKQEAgLTE5NCw1ICsxOTYsNyBAQCBlbnVtIHJxX2ZsYWdfYml0cyB7
CiAjZGVmaW5lIFJFUV9JT19TVEFUCQkoMSA8PCBfX1JFUV9JT19TVEFUKQogI2RlZmluZSBSRVFf
TUlYRURfTUVSR0UJCSgxIDw8IF9fUkVRX01JWEVEX01FUkdFKQogI2RlZmluZSBSRVFfU0VDVVJF
CQkoMSA8PCBfX1JFUV9TRUNVUkUpCisjZGVmaW5lIFJFUV9DTE9ORURfRkxVU0gJKDEgPDwgX19S
RVFfQ0xPTkVEX0ZMVVNIKQorI2RlZmluZSBSRVFfQ0xPTkVEX0ZVQQkJKDEgPDwgX19SRVFfQ0xP
TkVEX0ZVQSkKIAogI2VuZGlmIC8qIF9fTElOVVhfQkxLX1RZUEVTX0ggKi8K
--0016e64fcb7836ce7204aed613cc--
