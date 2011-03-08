Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756532Ab1CHImG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 03:42:06 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:49220 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756119Ab1CHImB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 03:42:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=dhxHPISVpCB8nNUu1v0j8afzoSAmI3YUWMObNgbQPvA4KpuDwQEIv0rEVEXELwJhUu
         YsO4eC26BCae724tLuquEphIzLbE1msH5jOkJMz68qTxELI7rX7IPTgiSmVwW4GIIm9f
         9r7cevrtxavMLwZacbU0U1Xc5MZByUxekVV4U=
MIME-Version: 1.0
In-Reply-To: <AANLkTinLe8bMUCTp8Kmv98=s8D8-1qUo78Vff_-Vpgfv@mail.gmail.com>
References: <20110303113435.GA2868@balbir.in.ibm.com>
	<20110303140551.GA20677@zhy>
	<AANLkTikHFLoJOZvx2YebKdHt+jjiHgUFasiLTrZ6vBUJ@mail.gmail.com>
	<AANLkTikqC=MNXXavJ_jxhFNQz1uNdABXVhvj82HW=BNA@mail.gmail.com>
	<20110304072517.GC2868@balbir.in.ibm.com>
	<AANLkTikuQKGS2SQArVBDo=5vOkyrNPdqXHPrOyQz3KdP@mail.gmail.com>
	<AANLkTi=gtnZ-uC-t6u9R=pNd_aSKE3YsXi_HUqnu5+VQ@mail.gmail.com>
	<AANLkTinMvkuxdrwgj4bS9MfVaimWx-DYaanhUD-bT_wO@mail.gmail.com>
	<AANLkTimy5mPqCEbMv_68XMa7Pq_n_-jq0Pdor8+ck64B@mail.gmail.com>
	<AANLkTi=CxyXHXpa-=CNyyJPOHe-OV0xGr3USKx+TyeqK@mail.gmail.com>
	<20110304121146.GG2868@balbir.in.ibm.com>
	<AANLkTinLe8bMUCTp8Kmv98=s8D8-1qUo78Vff_-Vpgfv@mail.gmail.com>
Date: Tue, 8 Mar 2011 16:42:00 +0800
Message-ID: <AANLkTi=9nivjLwxACYJUNS6nC0zqOo-EVZbh3am+Cs4C@mail.gmail.com>
Subject: Re: [BUGFIX][PATCH] Fix sched rt group scheduling when hierachy is enabled
From: Yong Zhang <yong.zhang0@gmail.com>
To: balbir@linux.vnet.ibm.com
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <pzijlstr@redhat.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Bharata B Rao <bharata.rao@in.ibm.com>
Content-Type: multipart/mixed; boundary=000e0cd47c58f8d121049df49530
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--000e0cd47c58f8d121049df49530
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 7, 2011 at 3:00 PM, Yong Zhang <yong.zhang0@gmail.com> wrote:
>
> I have tested with the attached(web mail will mangle it) patch with
> yours applied. But I failed to trigger that WARNING.
>
> Below is my steps:
> 1)mount -t cgroup -ocpu cpu /mnt
> 2)mkdir /mnt/test-1
> 3)mkdir /mnt/test-1-1
> 4)set rt_runtime to 100000 for test-1 and test-1-1
> 5)run a loop task and attach it to test-1-1
>
> So I thought out a scenario to satisfy your description,
> but it's based on the unpatched(without your patch) kernel:
> Let's assume a dual-core system with test-1/test-1-1
> for rt group, a loop task is running on CPU 1 and test-1
> and test-1-1 are both throttled.
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0CPU-0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0CPU-1
> do_sched_rt_period_timer(test-1-1)
> {
> =C2=A0for CPU-1
> =C2=A0 =C2=A0unthrottled test-1-1.rt_rq[1];
> =C2=A0 =C2=A0 =C2=A0but fail to enqueue it because
> =C2=A0 =C2=A0 =C2=A0we alway get test-1-1.rt_se[0]
> =C2=A0 =C2=A0 =C2=A0due to smp_processor_id();
> =C2=A0 =C2=A0 =C2=A0thus test-1.rt_rq[1].nr_running =3D=3D 0;
> =C2=A0 =C2=A0 =C2=A0and it returned with run_time =3D=3D 0;
> }
> do_sched_rt_period_timer(test-1)
> =C2=A0unthrottle test-1.rt_rt[1] but
> =C2=A0fail to enqueue test-1.rt_rt[1];
> =C2=A0because nr_running =3D=3D 0;
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 So if we have your patch for issue-1, when
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 the hrtimer is running on CPU-1, test-1-1
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 and test-1 will be queued because that
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 additional check in run_timer =3D=3D 0 case.
>
> But once we have your patch for issue-2, the above
> problem will be killed by it. right?

And another finding is that the top rt_rq could trigger your
additional code, but we don't need to enqueue
root_task_group.rt_se[].

BTW, I update my patch(attached) to void testing on top rt_rq.

Thanks,
Yong


--=20
Only stand for myself

--000e0cd47c58f8d121049df49530
Content-Type: text/x-patch; charset=US-ASCII; name="0001-updated.patch"
Content-Disposition: attachment; filename="0001-updated.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gl0k6mth1

ZGlmZiAtLWdpdCBhL2tlcm5lbC9zY2hlZF9ydC5jIGIva2VybmVsL3NjaGVkX3J0LmMKaW5kZXgg
MDFmNzVhNS4uYjAyYjUxNiAxMDA2NDQKLS0tIGEva2VybmVsL3NjaGVkX3J0LmMKKysrIGIva2Vy
bmVsL3NjaGVkX3J0LmMKQEAgLTU2OCw4ICs1NjgsMTQgQEAgc3RhdGljIGludCBkb19zY2hlZF9y
dF9wZXJpb2RfdGltZXIoc3RydWN0IHJ0X2JhbmR3aWR0aCAqcnRfYiwgaW50IG92ZXJydW4pCiAJ
CQlyYXdfc3Bpbl91bmxvY2soJnJ0X3JxLT5ydF9ydW50aW1lX2xvY2spOwogCQl9IGVsc2UgaWYg
KHJ0X3JxLT5ydF9ucl9ydW5uaW5nKSB7CiAJCQlpZGxlID0gMDsKLQkJCWlmICghcnRfcnFfdGhy
b3R0bGVkKHJ0X3JxKSkKKwkJCWlmICghcnRfcnFfdGhyb3R0bGVkKHJ0X3JxKSkgeworCQkJCXN0
cnVjdCBzY2hlZF9ydF9lbnRpdHkgKnJ0X3NlOworCQkJCWludCBjcHUgPSBjcHVfb2YocnFfb2Zf
cnRfcnEocnRfcnEpKTsKKworCQkJCXJ0X3NlID0gcnRfcnEtPnRnLT5ydF9zZVtjcHVdOworCQkJ
CVdBUk5fT04ocnRfc2UgJiYgIW9uX3J0X3JxKHJ0X3NlKSk7CiAJCQkJZW5xdWV1ZSA9IDE7CisJ
CQl9CiAJCX0KIAogCQlpZiAoZW5xdWV1ZSkK
--000e0cd47c58f8d121049df49530--
