Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759545Ab2CGSDa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 13:03:30 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:42316 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759493Ab2CGSD2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 13:03:28 -0500
MIME-Version: 1.0
In-Reply-To: <1331137905.11248.355.camel@twins>
References: <CAL1RGDUbxcx+cCM_mf1nFJ=Jz0SyaiW0ffxiY4gZ6KNWzJCnMg@mail.gmail.com>
 <1331137905.11248.355.camel@twins>
From: Roland Dreier <roland@kernel.org>
Date: Wed, 7 Mar 2012 10:03:07 -0800
X-Google-Sender-Auth: 2heHnJaMCM9_-kWPA51SPvqKDfc
Message-ID: <CAG4TOxM2yGvFo5O9x0M6H2GONPyF9XVOLwonfS-1gkpskkO+0w@mail.gmail.com>
Subject: Re: runnable tasks never making it to a runqueue where they can run?
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 7, 2012 at 8:31 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
>> 6,7,8,10,18,19,22 but never onto 23
>
>>   (Interestingly, those 8 CPUs seem to form a domain)
>
> That would be 'interesting'... I have a similar wsm box and you should
> have a domain setup like:
>
> 0-5,12-17  (node 0)
> 6-11,18-23 (node 1)
>
> Where the first set (0-5 & 6-11) is smt0 and the second set (12-17 &
> 18-23) smt1.
>
> Can you boot with sched_debug and send me both /proc/cpuinfo and dmesg?

Never mind, what I said was partially BS.  It is true that
I only see the thread on those runqueues.  However you are
right that the domain mask is 0xFC0FC0 (6-11,18-23), but
the thread has an affinity mask of 0xFFF5D7, so the CPUs
in the intersection are 0xFC05C0, ie 9 and 11 aren't in its
affinity mask.

The behavior is still a little strange -- the scheduler is trying
6,7,8,10 and their SMT siblings (I left out 20 by accident in
my list but it is there).  This is suggestive:

So could the fact that we don't have CPU 11 in our affinity
mask cause the scheduler not to try the CPU 23 runqueue?
Is it only looking at the first SMT sibling or something?

 - R.
