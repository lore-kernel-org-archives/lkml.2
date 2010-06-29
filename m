Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754603Ab0F2JHU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 05:07:20 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:56824 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754488Ab0F2JG4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 05:06:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=cWk8uSJObROzw6tf7x8y2Ev2Us5Ei8C4ku8XWATd0b2+1odnldvrH2ndVlIpe3NNsB
         Jj8Fx4QBMnr7GriCn0hCk/aAkA2h0DkQK/1BvQ2TWNXKkDKkAJGvmV7xNCH1NXD3RxP3
         E9h8DakaEkUW6INnga+tipwbWoIue0HGwHRT8=
MIME-Version: 1.0
In-Reply-To: <x49wrtk32g1.fsf@segfault.boston.devel.redhat.com>
References: <20100621094828.GA30748@lst.de>
	<4C1F3916.4070608@kernel.dk>
	<20100621110436.GA4056@lst.de>
	<4C1FB5F7.3070908@kernel.dk>
	<20100621191410.GA24213@lst.de>
	<20100621213618.GC6474@redhat.com>
	<20100623100138.GA9575@lst.de>
	<20100624014420.GB3297@redhat.com>
	<20100625110319.GA12855@lst.de>
	<20100626033509.GA2435@redhat.com>
	<x49wrtk32g1.fsf@segfault.boston.devel.redhat.com>
Date: Tue, 29 Jun 2010 11:06:19 +0200
Message-ID: <AANLkTiktd7GxqDkezq7LJ3vN8D0wFgzKePdQBAY3bz17@mail.gmail.com>
Subject: Re: trying to understand READ_META, READ_SYNC, WRITE_SYNC & co
From: Corrado Zoccolo <czoccolo@gmail.com>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Christoph Hellwig <hch@lst.de>,
       Jens Axboe <axboe@kernel.dk>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary=0016e65b656a3b3eec048a278e04
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0016e65b656a3b3eec048a278e04
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Sun, Jun 27, 2010 at 5:44 PM, Jeff Moyer <jmoyer@redhat.com> wrote:
> Vivek Goyal <vgoyal@redhat.com> writes:
>
>> On Fri, Jun 25, 2010 at 01:03:20PM +0200, Christoph Hellwig wrote:
>>> On Wed, Jun 23, 2010 at 09:44:20PM -0400, Vivek Goyal wrote:
>>> I see the point of this logic for reads where various workloads have
>>> dependent reads that might be close to each other, but I don't really
>>> see any point for writes.
>>>
>>> > So looks like fsync path will do bunch of IO and then will wait for j=
bd thread
>>> > to finish the work. In this case idling is waste of time.
>>>
>>> Given that ->writepage already does WRITE_SYNC_PLUG I/O which includes
>>> REQ_NODILE I'm still confused why we still have that issue.
>>
>> In current form, cfq honors REQ_NOIDLE conditionally and that's why we
>> still have the issue. If you look at cfq_completed_request(), we continu=
e
>> to idle in following two cases.
>>
>> - If we classifed the queue as SYNC_WORKLOAD.
>> - If there is another random read/write happening on sync-noidle service
>> =C2=A0 tree.
>>
>> SYNC_WORKLOAD means that cfq thinks this particular queue is doing seque=
ntial
>> IO. For random IO queues, we don't idle on each individual queue but a
>> group of queue.
>>
>> In jeff's testing, fsync thread/queue sometimes is viewed as sequential
>> workload and goes on SYNC_WORKLOAD tree. In that case even if request is
>> REQ_NOIDLE, we will continue to idle hence fsync issue.
>
> I'm now testing OCFS2, and I'm seeing performance that is not great
> (even with the blk_yield patches applied). =C2=A0What happens is that we
> successfully yield the queue to the journal thread, but then idle on the
> journal thread (even though RQ_NOIDLE was set).
>
> So, can we just get rid of idling when RQ_NOIDLE is set?
Hi Jeff,
I think I spotted a problem with the initial implementation of the
tree-wide idle when RQ_NOIDLE is set: I assumed that a queue would
either send possibly-idling requests or no-idle requests, but it seems
that RQ_NOIDLE is being used to mark the end of a stream of
possibly-idling requests (in my initial implementation, this will then
cause an unintended idle). The attached patch should fix it, and I
think the logic is simpler than Vivek's. Can you give it a spin?
Otherwise, I think that reverting the "noidle_tree_requires_idle"
behaviour completely may be better than adding complexity, since it is
really trying to solve corner cases (that maybe happen only on
synthetic workloads), but affecting negatively more common cases.

About what it is trying to solve, since I think it was not clear:
- we have a workload of 2 queues, both issuing requests that are being
put in the no-idle tree (e.g. they are random) + 1 queue issuing
idling requests (e.g. sequential).
- if one of the 2 "random" queues marks its requests as RQ_NOIDLE,
then the timeslice for the no-idle tree is not preserved, causing
unfairness, as soon as an RQ_NOIDLE request is serviced and the tree
is empty.

Thanks
Corrado

>
> Vivek sent me this patch to test, and it got rid of the performance
> issue for the fsync workload. =C2=A0Can we discuss its merits?
>
> Thanks,
> Jeff
>
> Index: linux-2.6/block/cfq-iosched.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-2.6.orig/block/cfq-iosched.c =C2=A02010-06-25 15:57:33.83212578=
6 -0400
> +++ linux-2.6/block/cfq-iosched.c =C2=A0 =C2=A0 =C2=A0 2010-06-25 15:59:1=
9.788876361 -0400
> @@ -318,6 +318,7 @@
> =C2=A0 =C2=A0 =C2=A0 =C2=A0CFQ_CFQQ_FLAG_split_coop, =C2=A0 =C2=A0 =C2=A0=
 /* shared cfqq will be splitted */
> =C2=A0 =C2=A0 =C2=A0 =C2=A0CFQ_CFQQ_FLAG_deep, =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 /* sync cfqq experienced large depth */
> =C2=A0 =C2=A0 =C2=A0 =C2=A0CFQ_CFQQ_FLAG_wait_busy, =C2=A0 =C2=A0 =C2=A0 =
=C2=A0/* Waiting for next request */
> + =C2=A0 =C2=A0 =C2=A0 CFQ_CFQQ_FLAG_group_idle, =C2=A0 =C2=A0 =C2=A0 /* =
This queue is doing group idle */
> =C2=A0};
>
> =C2=A0#define CFQ_CFQQ_FNS(name) =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 \
> @@ -347,6 +348,7 @@
> =C2=A0CFQ_CFQQ_FNS(split_coop);
> =C2=A0CFQ_CFQQ_FNS(deep);
> =C2=A0CFQ_CFQQ_FNS(wait_busy);
> +CFQ_CFQQ_FNS(group_idle);
> =C2=A0#undef CFQ_CFQQ_FNS
>
> =C2=A0#ifdef CONFIG_CFQ_GROUP_IOSCHED
> @@ -1613,6 +1615,7 @@
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0cfq_clear_cfqq_wait_request(cfqq);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0cfq_clear_cfqq_wait_busy(cfqq);
> + =C2=A0 =C2=A0 =C2=A0 cfq_clear_cfqq_group_idle(cfqq);
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0/*
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 * If this cfqq is shared between multiple pro=
cesses, check to
> @@ -3176,6 +3179,13 @@
> =C2=A0 =C2=A0 =C2=A0 =C2=A0if (cfq_class_rt(new_cfqq) && !cfq_class_rt(cf=
qq))
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return true;
>
> + =C2=A0 =C2=A0 =C2=A0 /*
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0* If were doing group_idle and we got new re=
quest in same group,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0* preempt the queue
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0*/
> + =C2=A0 =C2=A0 =C2=A0 if (cfq_cfqq_group_idle(cfqq))
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return true;
> +
> =C2=A0 =C2=A0 =C2=A0 =C2=A0if (!cfqd->active_cic || !cfq_cfqq_wait_reques=
t(cfqq))
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return false;
>
> @@ -3271,6 +3281,7 @@
> =C2=A0 =C2=A0 =C2=A0 =C2=A0struct cfq_queue *cfqq =3D RQ_CFQQ(rq);
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0cfq_log_cfqq(cfqd, cfqq, "insert_request");
> + =C2=A0 =C2=A0 =C2=A0 cfq_clear_cfqq_group_idle(cfqq);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0cfq_init_prio_data(cfqq, RQ_CIC(rq)->ioc);
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0rq_set_fifo_time(rq, jiffies + cfqd->cfq_fifo_=
expire[rq_is_sync(rq)]);
> @@ -3416,10 +3427,12 @@
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 * SYNC_NOIDLE_WORKLOAD idles at the end of the tree
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 * only if we processed at least one !rq_noidle request
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 */
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 if (cfqd->serving_type =3D=3D SYNC_WORKLOAD
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 || cfqd->noidle_tree_requires_idle
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 || cfqq->cfqg->nr_cfqq =3D=3D 1)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 if (cfqd->noidle_tree_requires_idle)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cfq_arm_slice_timer(cfqd);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 else if (cfqq->cfqg->nr_cfqq =3D=3D 1) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cfq_mark_cfqq_group_idle(cfqq);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0cfq_arm_slice_timer(cfqd);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 }
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> =C2=A0 =C2=A0 =C2=A0 =C2=A0}
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" i=
n
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at =C2=A0http://www.tux.org/lkml/
>



--=20
__________________________________________________________________________

dott. Corrado Zoccolo                          mailto:czoccolo@gmail.com
PhD - Department of Computer Science - University of Pisa, Italy
--------------------------------------------------------------------------
The self-confidence of a warrior is not the self-confidence of the average
man. The average man seeks certainty in the eyes of the onlooker and calls
that self-confidence. The warrior seeks impeccability in his own eyes and
calls that humbleness.
                               Tales of Power - C. Castaneda



Hi

--0016e65b656a3b3eec048a278e04
Content-Type: text/x-patch; charset=US-ASCII; 
	name="0001-cfq-iosched-fix-tree-wide-handling-of-rq_noidle.patch"
Content-Disposition: attachment; 
	filename="0001-cfq-iosched-fix-tree-wide-handling-of-rq_noidle.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gb0i4wql0

RnJvbSAzMGJkZjcwMjYwNGYzMDQ2MDdhYzhhOTg2ZDdkODkyODVjNzE0MWZhIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBDb3JyYWRvIFpvY2NvbG8gPGN6b2Njb2xvQGdtYWlsLmNvbT4K
RGF0ZTogVHVlLCAyOSBKdW4gMjAxMCAxMDo0ODoyMSArMDIwMApTdWJqZWN0OiBbUEFUQ0hdIGNm
cS1pb3NjaGVkOiBmaXggdHJlZS13aWRlIGhhbmRsaW5nIG9mIHJxX25vaWRsZQoKUGF0Y2g6IDhl
NTUwNjMgY2ZxLWlvc2NoZWQ6IGZpeCBjb3JuZXIgY2FzZXMgaW4gaWRsaW5nIGxvZ2ljCmludHJv
ZHVjZWQgdGhlIHBvc3NpYmlsaXR5IG9mIGlkaW5nIGV2ZW4gb24gbm8taWRsZSByZXF1ZXN0cwpp
biB0aGUgbm9faWRsZSB0cmVlLCBpZiBhbnkgcHJldmlvdXMgcmVxdWVzdCBpbiB0aGUgY3VycmVu
dCBzbGljZQpjb3VsZCBpZGxlLiBUaGUgaW1wbGVtZW50YXRpb24gaGFkIGEgcHJvYmxlbSwgdGhv
dWdoOgotIGlmIGEgcXVldWUgc2VudCBzZXZlcmFsIHBvc3NpYmx5IGlkbGluZyByZXF1ZXN0cyBh
bmQgYSBub2lkbGUKICByZXF1ZXN0IGFzIGxhc3Qgb25lIGluIHRoZSBzYW1lIHRpbWUgc2xpY2Us
IHRoZSB0cmVlIHdhcyBzdGlsbAogIG1hcmtlZCBhcyBpZGxlLgpUaGlzIHBhdGNoIGZpeGVzIHRo
aXMgbWlzYmVoYXZpb3VyLCBieSB1c2luZyBhIDMxLWJ1Y2tldCBoYXNoIHRvCmtlZXAgaWRsaW5n
L25vbi1pZGxpbmcgc3RhdHVzIGZvciBxdWV1ZXMgaW4gdGhlIG5vaWRsZSB0cmVlLgoKU2lnbmVk
LW9mZi1ieTogQ29ycmFkbyBab2Njb2xvIDxjem9jY29sb0BnbWFpbC5jb20+Ci0tLQogYmxvY2sv
Y2ZxLWlvc2NoZWQuYyB8ICAgMTEgKysrKysrKystLS0KIDEgZmlsZXMgY2hhbmdlZCwgOCBpbnNl
cnRpb25zKCspLCAzIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2Jsb2NrL2NmcS1pb3NjaGVk
LmMgYi9ibG9jay9jZnEtaW9zY2hlZC5jCmluZGV4IGQxYWQwNjYuLjVlZjlhNWQgMTAwNjQ0Ci0t
LSBhL2Jsb2NrL2NmcS1pb3NjaGVkLmMKKysrIGIvYmxvY2svY2ZxLWlvc2NoZWQuYwpAQCAtMjE0
LDcgKzIxNCw3IEBAIHN0cnVjdCBjZnFfZGF0YSB7CiAJZW51bSB3bF90eXBlX3Qgc2VydmluZ190
eXBlOwogCXVuc2lnbmVkIGxvbmcgd29ya2xvYWRfZXhwaXJlczsKIAlzdHJ1Y3QgY2ZxX2dyb3Vw
ICpzZXJ2aW5nX2dyb3VwOwotCWJvb2wgbm9pZGxlX3RyZWVfcmVxdWlyZXNfaWRsZTsKKwl1MzIg
bm9pZGxlX3RyZWVfcmVxdWlyZXNfaWRsZTsKIAogCS8qCiAJICogRWFjaCBwcmlvcml0eSB0cmVl
IGlzIHNvcnRlZCBieSBuZXh0X3JlcXVlc3QgcG9zaXRpb24uICBUaGVzZQpAQCAtMjA2Niw3ICsy
MDY2LDcgQEAgc3RhdGljIHZvaWQgY2hvb3NlX3NlcnZpY2VfdHJlZShzdHJ1Y3QgY2ZxX2RhdGEg
KmNmcWQsIHN0cnVjdCBjZnFfZ3JvdXAgKmNmcWcpCiAJc2xpY2UgPSBtYXhfdCh1bnNpZ25lZCwg
c2xpY2UsIENGUV9NSU5fVFQpOwogCWNmcV9sb2coY2ZxZCwgIndvcmtsb2FkIHNsaWNlOiVkIiwg
c2xpY2UpOwogCWNmcWQtPndvcmtsb2FkX2V4cGlyZXMgPSBqaWZmaWVzICsgc2xpY2U7Ci0JY2Zx
ZC0+bm9pZGxlX3RyZWVfcmVxdWlyZXNfaWRsZSA9IGZhbHNlOworCWNmcWQtPm5vaWRsZV90cmVl
X3JlcXVpcmVzX2lkbGUgPSAwVTsKIH0KIAogc3RhdGljIHN0cnVjdCBjZnFfZ3JvdXAgKmNmcV9n
ZXRfbmV4dF9jZnFnKHN0cnVjdCBjZnFfZGF0YSAqY2ZxZCkKQEAgLTMzNDksNyArMzM0OSwxMiBA
QCBzdGF0aWMgdm9pZCBjZnFfY29tcGxldGVkX3JlcXVlc3Qoc3RydWN0IHJlcXVlc3RfcXVldWUg
KnEsIHN0cnVjdCByZXF1ZXN0ICpycSkKIAkJCWNmcV9zbGljZV9leHBpcmVkKGNmcWQsIDEpOwog
CQllbHNlIGlmIChzeW5jICYmIGNmcXFfZW1wdHkgJiYKIAkJCSAhY2ZxX2Nsb3NlX2Nvb3BlcmF0
b3IoY2ZxZCwgY2ZxcSkpIHsKLQkJCWNmcWQtPm5vaWRsZV90cmVlX3JlcXVpcmVzX2lkbGUgfD0g
IXJxX25vaWRsZShycSk7CisJCQl1MzIgYml0bWFzayA9IDFVIDw8ICgoKGludCljZnFxKSAlIDMx
KTsKKwkJCWlmIChycV9ub2lkbGUocnEpKQorCQkJCWNmcWQtPm5vaWRsZV90cmVlX3JlcXVpcmVz
X2lkbGUgJj0gfmJpdG1hc2s7CisJCQllbHNlCisJCQkJY2ZxZC0+bm9pZGxlX3RyZWVfcmVxdWly
ZXNfaWRsZSB8PSBiaXRtYXNrOworCiAJCQkvKgogCQkJICogSWRsaW5nIGlzIGVuYWJsZWQgZm9y
IFNZTkNfV09SS0xPQUQuCiAJCQkgKiBTWU5DX05PSURMRV9XT1JLTE9BRCBpZGxlcyBhdCB0aGUg
ZW5kIG9mIHRoZSB0cmVlCi0tIAoxLjYuNC40Cgo=
--0016e65b656a3b3eec048a278e04--
