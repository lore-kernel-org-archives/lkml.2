Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753538Ab1CGHA1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 02:00:27 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:48030 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750972Ab1CGHAZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 02:00:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=waNHzmtfsAhTga2+2NwY+6YoKQxqysOvZPvVc+gmKkz0X47Rd7m7ouWZd+EZP8svnz
         9+KMYDHqw0hEBWJ58v0d8al5HFCNxW+TLATU18QkxI9BsSvOapUAjdDT4jnuXcH+5/Vq
         Kdq00snq1sBO3/+HYajotPR2zYIYX8+l0X+fY=
MIME-Version: 1.0
In-Reply-To: <20110304121146.GG2868@balbir.in.ibm.com>
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
Date: Mon, 7 Mar 2011 15:00:24 +0800
Message-ID: <AANLkTinLe8bMUCTp8Kmv98=s8D8-1qUo78Vff_-Vpgfv@mail.gmail.com>
Subject: Re: [BUGFIX][PATCH] Fix sched rt group scheduling when hierachy is enabled
From: Yong Zhang <yong.zhang0@gmail.com>
To: balbir@linux.vnet.ibm.com
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <pzijlstr@redhat.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Bharata B Rao <bharata.rao@in.ibm.com>
Content-Type: multipart/mixed; boundary=000e0cd47c58cd9725049ddf0cd0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--000e0cd47c58cd9725049ddf0cd0
Content-Type: text/plain; charset=UTF-8

On Fri, Mar 4, 2011 at 8:11 PM, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> I based the changes on what I saw during my debugging/test. I
> explained it earlier,
>
> Everyone is dequeued
>
> 1. child runs first, finds parent throttled, so it does not queue
> anything on parent group. child is unthrottled and rt_time now becomes
> 0, parent's rt_nr_running is not incremented.
> 2. Parent timer runs, it is unthrottled, its group->rt_nr_running is 0
> hence enqueue is not called

I have tested with the attached(web mail will mangle it) patch with
yours applied. But I failed to trigger that WARNING.

Below is my steps:
1)mount -t cgroup -ocpu cpu /mnt
2)mkdir /mnt/test-1
3)mkdir /mnt/test-1-1
4)set rt_runtime to 100000 for test-1 and test-1-1
5)run a loop task and attach it to test-1-1

So I thought out a scenario to satisfy your description,
but it's based on the unpatched(without your patch) kernel:
Let's assume a dual-core system with test-1/test-1-1
for rt group, a loop task is running on CPU 1 and test-1
and test-1-1 are both throttled.

              CPU-0                                  CPU-1
do_sched_rt_period_timer(test-1-1)
{
  for CPU-1
    unthrottled test-1-1.rt_rq[1];
      but fail to enqueue it because
      we alway get test-1-1.rt_se[0]
      due to smp_processor_id();
      thus test-1.rt_rq[1].nr_running == 0;
      and it returned with run_time == 0;
}
do_sched_rt_period_timer(test-1)
  unthrottle test-1.rt_rt[1] but
  fail to enqueue test-1.rt_rt[1];
  because nr_running == 0;

                           So if we have your patch for issue-1, when
                           the hrtimer is running on CPU-1, test-1-1
                           and test-1 will be queued because that
                           additional check in run_timer == 0 case.

But once we have your patch for issue-2, the above
problem will be killed by it. right?

Correct me if I'm wrong :)

Thanks,
Yong


-- 
Only stand for myself

--000e0cd47c58cd9725049ddf0cd0
Content-Type: text/x-patch; charset=US-ASCII; name="0001.patch"
Content-Disposition: attachment; filename="0001.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gkz0kqlz0

ZGlmZiAtLWdpdCBhL2tlcm5lbC9zY2hlZF9ydC5jIGIva2VybmVsL3NjaGVkX3J0LmMKaW5kZXgg
MDFmNzVhNS4uN2U0ODM5YyAxMDA2NDQKLS0tIGEva2VybmVsL3NjaGVkX3J0LmMKKysrIGIva2Vy
bmVsL3NjaGVkX3J0LmMKQEAgLTU2OCw4ICs1NjgsMTIgQEAgc3RhdGljIGludCBkb19zY2hlZF9y
dF9wZXJpb2RfdGltZXIoc3RydWN0IHJ0X2JhbmR3aWR0aCAqcnRfYiwgaW50IG92ZXJydW4pCiAJ
CQlyYXdfc3Bpbl91bmxvY2soJnJ0X3JxLT5ydF9ydW50aW1lX2xvY2spOwogCQl9IGVsc2UgaWYg
KHJ0X3JxLT5ydF9ucl9ydW5uaW5nKSB7CiAJCQlpZGxlID0gMDsKLQkJCWlmICghcnRfcnFfdGhy
b3R0bGVkKHJ0X3JxKSkKKwkJCWlmICghcnRfcnFfdGhyb3R0bGVkKHJ0X3JxKSkgeworCQkJCWlu
dCBjcHUgPSBjcHVfb2YocnFfb2ZfcnRfcnEocnRfcnEpKTsKKworCQkJCVdBUk5fT04oIW9uX3J0
X3JxKHJ0X3JxLT50Zy0+cnRfc2VbY3B1XSkpOwogCQkJCWVucXVldWUgPSAxOworCQkJfQogCQl9
CiAKIAkJaWYgKGVucXVldWUpCg==
--000e0cd47c58cd9725049ddf0cd0--
