Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753965Ab1CUQnt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 12:43:49 -0400
Received: from mx5.twosigma.com ([208.77.212.35]:63266 "EHLO mx5.twosigma.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753949Ab1CUQnp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 12:43:45 -0400
X-Greylist: delayed 1427 seconds by postgrey-1.27 at vger.kernel.org; Mon, 21 Mar 2011 12:43:45 EDT
From: Sean Noonan <Sean.Noonan@twosigma.com>
To: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>
CC: Trammell Hudson <Trammell.Hudson@twosigma.com>,
        Martin Bligh <Martin.Bligh@twosigma.com>,
        Stephen Degler <Stephen.Degler@twosigma.com>,
        Christos Zoulas <Christos.Zoulas@twosigma.com>
Date: Mon, 21 Mar 2011 12:19:44 -0400
Subject: XFS memory allocation deadlock in 2.6.38
Thread-Topic: XFS memory allocation deadlock in 2.6.38
Thread-Index: Acvn48onhwj/45wTTJCiJ9OQbQPjgA==
Message-ID: <081DDE43F61F3D43929A181B477DCA95639B52FD@MSXAOA6.twosigma.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: multipart/mixed;
	boundary="_002_081DDE43F61F3D43929A181B477DCA95639B52FDMSXAOA6twosigma_"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--_002_081DDE43F61F3D43929A181B477DCA95639B52FDMSXAOA6twosigma_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

This message was originally posted to the XFS mailing list, but received no=
 responses.  Thus, I am sending it to LKML on the advice of Martin.

Using the attached program, we are able to reproduce this bug reliably.
$ make vmtest
$ ./vmtest /xfs/hugefile.dat $(( 16 * 1024 * 1024 * 1024 )) # vmtest <path_=
to_file> <size_in_bytes>
/xfs/hugefile.dat: mapped 17179869184 bytes in 33822066943 ticks
749660: avg 13339 max 234667 ticks
371945: avg 26885 max 281616 ticks
---
At this point, we see the following on the console:
[593492.694806] XFS: possible memory allocation deadlock in kmem_alloc (mod=
e:0x250)
[593506.724367] XFS: possible memory allocation deadlock in kmem_alloc (mod=
e:0x250)
[593524.837717] XFS: possible memory allocation deadlock in kmem_alloc (mod=
e:0x250)
[593556.742386] XFS: possible memory allocation deadlock in kmem_alloc (mod=
e:0x250)

This is the same message presented in
http://oss.sgi.com/bugzilla/show_bug.cgi?id=3D410

We started testing with 2.6.38-rc7 and have seen this bug through to the .0=
 release.  This does not appear to be present in 2.6.33, but we have not do=
ne testing in between.  We have tested with ext4 and do not encounter this =
bug.
CONFIG_XFS_FS=3Dy
CONFIG_XFS_QUOTA=3Dy
CONFIG_XFS_POSIX_ACL=3Dy
CONFIG_XFS_RT=3Dy
# CONFIG_XFS_DEBUG is not set
# CONFIG_VXFS_FS is not set

Here is the stack from the process:
[<ffffffff81357553>] call_rwsem_down_write_failed+0x13/0x20
[<ffffffff812ddf1e>] xfs_ilock+0x7e/0x110
[<ffffffff8130132f>] __xfs_get_blocks+0x8f/0x4e0
[<ffffffff813017b1>] xfs_get_blocks+0x11/0x20
[<ffffffff8114ba3e>] __block_write_begin+0x1ee/0x5b0
[<ffffffff8114be9d>] block_page_mkwrite+0x9d/0xf0
[<ffffffff81307e05>] xfs_vm_page_mkwrite+0x15/0x20
[<ffffffff810f2ddb>] do_wp_page+0x54b/0x820
[<ffffffff810f347c>] handle_pte_fault+0x3cc/0x820
[<ffffffff810f5145>] handle_mm_fault+0x175/0x2f0
[<ffffffff8102e399>] do_page_fault+0x159/0x470
[<ffffffff816cf6cf>] page_fault+0x1f/0x30
[<ffffffffffffffff>] 0xffffffffffffffff

# uname -a
Linux testhost 2.6.38 #2 SMP PREEMPT Fri Mar 18 15:00:59 GMT 2011 x86_64 GN=
U/Linux

Please let me know if additional information is required.

Thanks!

Sean

--_002_081DDE43F61F3D43929A181B477DCA95639B52FDMSXAOA6twosigma_
Content-Type: text/plain; name="vmtest.c"
Content-Description: vmtest.c
Content-Disposition: attachment; filename="vmtest.c"; size=2185;
	creation-date="Mon, 21 Mar 2011 12:18:51 GMT";
	modification-date="Mon, 21 Mar 2011 12:18:51 GMT"
Content-Transfer-Encoding: base64

I2luY2x1ZGUgPHN0ZGlvLmg+CiNpbmNsdWRlIDxzdGRsaWIuaD4KI2luY2x1ZGUgPHN0ZGludC5o
PgojaW5jbHVkZSA8c3lzL21tYW4uaD4KI2luY2x1ZGUgPHN5cy90eXBlcy5oPgojaW5jbHVkZSA8
c3lzL3N0YXQuaD4KI2luY2x1ZGUgPHVuaXN0ZC5oPgojaW5jbHVkZSA8c3RkaW50Lmg+CiNpbmNs
dWRlIDxpbnR0eXBlcy5oPgojaW5jbHVkZSA8ZXJybm8uaD4KI2luY2x1ZGUgPGZjbnRsLmg+CiNp
bmNsdWRlIDxlcnIuaD4KCgpzdGF0aWMgaW5saW5lIHVpbnQ2NF90CnJkdHNjKHZvaWQpCnsKICAg
IHVpbnQzMl90IGxvdywgaGlnaDsKICAgIF9fYXNtX18gX192b2xhdGlsZV9fKCJyZHRzYyIgOiAi
PWEiKGxvdyksICI9ZCIoaGlnaCkpOwogICAgcmV0dXJuIGxvdyB8ICgodWludDY0X3QpIGhpZ2gp
IDw8IDMyOwp9CgoKdm9pZCAqCm1tYXBmaWxlKAogICAgY29uc3QgY2hhciAqIGZpbGVuYW1lLAog
ICAgdWludDY0X3QgbGVuCikKewogICAgaW50IHBlcm1zID0gMDY2NjsKICAgIGludCBvcGVuX2Zs
YWcgPSBPX1JEV1IgfCBPX0NSRUFUOwogICAgaW50IG1tYXBfZmxhZ3MgPSBQUk9UX1JFQUQgfCBQ
Uk9UX1dSSVRFOwoKICAgIGNvbnN0IGludCBmZCA9IG9wZW4oZmlsZW5hbWUsIG9wZW5fZmxhZywg
cGVybXMpOwogICAgaWYgKGZkIDwgMCkKCWdvdG8gZmFpbDsKCiAgICAvLyBFbnN1cmUgdGhhdCB0
aGUgZmlsZSBpcyBlbXB0eSBhbmQgdGhlIHJpZ2h0IHNpemUKICAgIGlmIChmdHJ1bmNhdGUoZmQs
IDApIDwgMCkKCWdvdG8gZmFpbDsKCiAgICBpZiAoZnRydW5jYXRlKGZkLCBsZW4pIDwgMCkKCWdv
dG8gZmFpbDsKCiAgICAvLyBNYXAgdGhlIGVudGlyZSBhY3R1YWwgbGVuZ3RoIG9mIHRoZSBmaWxl
CiAgICB2b2lkICogY29uc3QgYmFzZSA9IG1tYXAoCglOVUxMLAoJbGVuLAoJbW1hcF9mbGFncywK
CU1BUF9TSEFSRUQgfCBNQVBfUE9QVUxBVEUsCglmZCwKCTAKICAgICk7CiAgICBpZiAoYmFzZSA9
PSBNQVBfRkFJTEVEKQoJZ290byBmYWlsOwoKICAgIGNsb3NlKGZkKTsKICAgIHJldHVybiBiYXNl
OwoKZmFpbDoKICAgIGVycigxLCAiJXM6IFVuYWJsZSB0byBtYXAgJSJQUkl1NjQiIGJ5dGVzIiwg
ZmlsZW5hbWUsIGxlbik7Cn0KCgppbnQgbWFpbigKICAgIGludCBhcmdjLAogICAgY2hhciAqKiBh
cmd2CikKewogICAgY29uc3QgY2hhciAqIGZpbGVuYW1lID0gYXJndlsxXTsKICAgIGNvbnN0IHVp
bnQ2NF90IGxlbiA9IGFyZ2MgPiAyID8gc3RydG91bChhcmd2WzJdLCBOVUxMLCAwKSA6ICg1dWwg
PDwgMzApOwogICAgY29uc3QgdWludDY0X3QgbWF4X2luZGV4ID0gbGVuIC8gc2l6ZW9mKHVpbnQ2
NF90KTsKCiAgICB1aW50NjRfdCBtbWFwX3RpbWUgPSAtcmR0c2MoKTsKICAgIHVpbnQ2NF90ICog
Y29uc3QgYnVmID0gbW1hcGZpbGUoZmlsZW5hbWUsIGxlbik7CiAgICBtbWFwX3RpbWUgKz0gcmR0
c2MoKTsKICAgIGZwcmludGYoc3RkZXJyLCAiJXM6IG1hcHBlZCAlIlBSSXU2NCIgYnl0ZXMgaW4g
JSJQUkl1NjQiIHRpY2tzXG4iLAoJZmlsZW5hbWUsCglsZW4sCgltbWFwX3RpbWUKICAgICk7Cgog
ICAgd2hpbGUgKDEpCiAgICB7Cgl1aW50NjRfdCBtYXggPSAwOwoJdWludDY0X3Qgc3VtID0gMDsK
CXVpbnQ2NF90IGk7Cgljb25zdCB1aW50NjRfdCBsb29wX3N0YXJ0ID0gcmR0c2MoKTsKCWNvbnN0
IHVpbnQ2NF90IGl0ZXJzID0gMSA8PCAzMDsKCgl1aW50NjRfdCBzdGFydCA9IGxvb3Bfc3RhcnQ7
Cglmb3IgKGkgPSAwIDsgaSA8IGl0ZXJzIDsgaSsrKQoJewoJICAgIHVpbnQ2NF90IGkgPSBscmFu
ZDQ4KCkgJSBtYXhfaW5kZXg7CgkgICAgYnVmW2ldICs9IHN0YXJ0OwoKCSAgICB1aW50NjRfdCBl
bmQgPSByZHRzYygpOwoJICAgIGNvbnN0IHVpbnQ2NF90IGRlbHRhID0gZW5kIC0gc3RhcnQ7Cgkg
ICAgc3RhcnQgPSBlbmQ7CgoJICAgIHN1bSArPSBkZWx0YTsKCSAgICBpZiAoZGVsdGEgPiBtYXgp
CgkJbWF4ID0gZGVsdGE7CgoJICAgIC8vIEZvcmNlIGEgcmVwb3J0IGV2ZXJ5IDEwIGJpbGxpb24g
dGlja3Mgfj0gMyBzZWNvbmRzCgkgICAgaWYgKGVuZCAtIGxvb3Bfc3RhcnQgPiAxMGU5KQoJCWJy
ZWFrOwoJfQoKCXByaW50ZigiJSJQUkl1NjQiOiBhdmcgJSJQUkl1NjQiIG1heCAlIlBSSXU2NCIg
dGlja3NcbiIsCgkgICAgaSwKCSAgICBpID8gc3VtIC8gaSA6IDAsCgkgICAgbWF4CgkpOwogICAg
fQoKICAgIHJldHVybiAwOwp9Cg==

--_002_081DDE43F61F3D43929A181B477DCA95639B52FDMSXAOA6twosigma_--
