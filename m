Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752213Ab2F3Uv0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2012 16:51:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62362 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750887Ab2F3UvZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2012 16:51:25 -0400
Message-ID: <4FEF66C4.20001@redhat.com>
Date: Sat, 30 Jun 2012 22:51:16 +0200
From: Zdenek Kabelac <zkabelac@redhat.com>
Organization: Red Hat
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Hugh Dickins <hughd@google.com>
CC: LVM general discussion and development <linux-lvm@redhat.com>,
        amwang@redhat.com, Alasdair G Kergon <agk@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: Regression with FALLOC_FL_PUNCH_HOLE in 3.5-rc kernel
References: <4FEEE5E5.5060800@redhat.com> <alpine.LSU.2.00.1206301217590.1728@eggly.anvils>
In-Reply-To: <alpine.LSU.2.00.1206301217590.1728@eggly.anvils>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne 30.6.2012 21:55, Hugh Dickins napsal(a):
> On Sat, 30 Jun 2012, Zdenek Kabelac wrote:
>>
>> When I've used 3.5-rc kernels - I've noticed kernel deadlocks.
>> Ooops log included. After some experimenting - reliable way to hit this oops
>> is to run lvm test suite for 10 minutes. Since 3.5 merge window does not
>> included anything related to this oops I've went for bisect.
>
> Thanks a lot for reporting, and going to such effort to find
> a reproducible testcase that you could bisect on.
>
>>
>> Game result is commit: 3f31d07571eeea18a7d34db9af21d2285b807a17
>>
>> mm/fs: route MADV_REMOVE to FALLOC_FL_PUNCH_HOLE
>
> But this leaves me very puzzled.
>
> Is the "lvm test suite" what I find at git.fedorahosted.org/git/lvm2.git
> under tests/ ?

Yes - that's it -

  make
as root:
  cd test
  make check_local

(inside test subdirectory should be enough, if not - just report any problem)

>
> I see no mention of madvise or MADV_REMOVE or fallocate or anything
> related in that git tree.
>
> If you have something else running at the same time, which happens to use
> madvise(,,MADV_REMOVE) on a filesystem which the commit above now enables
> it on (I guess ext4 from the =y in your config), then I suppose we should
> start searching for improper memory freeing or scribbling in its holepunch
> support: something that might be corrupting the dm_region in your oops.

What the test is doing - it creates file in  LVM_TEST_DIR (default is /tmp)
and using loop device to simulate device (small size - it should fit bellow 200MB)

Within this file second layer through virtual DM devices is created and 
simulates various numbers of PV devices to play with.

So since everything now support TRIM - such operations should be passed
down to the backend file - which probably triggers the path.

> I'll be surprised if that is the case, but it's something that you can
> easily check by inserting a WARN_ON(1) in mm/madvise.c madvise_remove():
> that should tell us what process is using it.

I could try that if that will help.

> I'm not an LVM user, so I doubt I'll be able to reproduce your setup.

Shouldn't be hard to run - unsure if every config setup is influnenced
or just mine config.

>
> Any ideas from the DM guys?  Has anyone else seen anything like this?
>
> Do all your oopses look like this one?

I think I've get yet another one - but also within  dm_rh_region

It could be that your patch exposed problem of some different part of stack - 
not really sure - it's just now with 3.5  this crash will not allow to pass 
whole test suite  -  I've tried also in kvm machine and it's been reproducible 
(so in the worst case I could eventually send you 2GB image)

The problem is - there is not a 'single test case' to trigger the oops (at 
least I've not figured out one)  - it's the combination of multiple tests 
running after each other - but for simplication this should be enough:

make check_local T=shell/lvconvert

Which usually dies on shell/lvconvert-repair-transient.sh

Zdenek
