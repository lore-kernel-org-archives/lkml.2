Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750897Ab0KFEGw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Nov 2010 00:06:52 -0400
Received: from serrano.cc.columbia.edu ([128.59.29.6]:65305 "EHLO
	serrano.cc.columbia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750717Ab0KFEGu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Nov 2010 00:06:50 -0400
Message-ID: <4CD4D431.7030104@cs.columbia.edu>
Date: Sat, 06 Nov 2010 00:06:09 -0400
From: Oren Laadan <orenl@cs.columbia.edu>
Organization: Columbia University
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.15) Gecko/20101027 Lightning/1.0b1 Thunderbird/3.0.10
MIME-Version: 1.0
To: Matt Helsley <matthltc@us.ibm.com>
CC: Gene Cooperman <gene@ccs.neu.edu>, "Luck, Tony" <tony.luck@intel.com>,
        Kapil Arya <kapil@ccs.neu.edu>,
        "ksummit-2010-discuss@lists.linux-foundation.org" 
	<ksummit-2010-discuss@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Ksummit-2010-discuss] checkpoint-restart: naked patch
References: <Pine.LNX.4.64.1011021530470.12128@takamine.ncl.cs.columbia.edu> <4CD08419.5050803@kernel.org> <4CD23087.30900@cs.columbia.edu> <AANLkTikgPKeZUih6_12JWSNy=Vsz2UP9HR7wHOz4q6ST@mail.gmail.com> <987664A83D2D224EAE907B061CE93D53016485FE6E@orsmsx505.amr.corp.intel.com> <20101105171703.GA1760@sundance.ccs.neu.edu> <20101106011610.GA12449@count0.beaverton.ibm.com>
In-Reply-To: <20101106011610.GA12449@count0.beaverton.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-No-Spam-Score: Local
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 11/05/2010 09:16 PM, Matt Helsley wrote:
> On Fri, Nov 05, 2010 at 01:17:03PM -0400, Gene Cooperman wrote:
>> On Fri, Nov 05, 2010 at 04:57:33AM -0700, Luck, Tony wrote:
>>>> Oren noted that sometimes it's important to stop the process only
>>>> for a few milliseconds while one checkpoints. In DMTCP, we do that
>>>> by configuring with --enable-forked-checkpointing. This causes us
>>>> to fork a child process taking advantage of copy-on-write and then
>>>> checkpoint the memory pages of the child while the parent continues
>>>> to execute.
>>>
>>> Interesting ... but while the process is only stopped for the duration
>>> of the fork, it may be taking COW faults on almost every page it
>>> touches.  I think this will not work well for large HPC applications
>>> that allocate most of physical memory as anonymous pages for the
>>> application. It may even result in an OOM kill if you don't complete
>>> the checkpoint of the child and have it exit in a timely manner.
>>>
>>> -Tony
>>>
>>
>> I agree with you that forked checkpointing is probably not what you
>> want in the middle of an HPC computation.  But isn't that part of
>> the nature of COW?  Whether the COW is invoked within the kernel,
>> or from outside the kernel via fork --- in either case, when you have
>> mostly dirty pages, you will have to copy most of the pages.
> 
> The current linux-cr approach to handling [dirty] pages doesn't use COW.
> The tasks are frozen using the cgroup freezer and thus unable to modify
> the pages. So we don't have to mess with page tables nor do we pay
> any extra overhead for page faults.

The current linux-cr patchset leaves out any optimizations
for simplicity of reviewing - first get it working and reviewed.
We experienced with optimizations with previous systems.

> 
> If we ever implement thawed checkpointing -- checkpointing while
> the task isn't frozen -- then we'd probably use COW and see
> the same faults. The difference then would be that in-kernel we
> wouldn't have one extra task per mm being checkpointed.

Thawed checkpointing can be done with any COW tax, by leveraging
the native hardware dirty bit in page tables. There is no need to
trigger additional checkpoints. Tracking modified pages using the
dirty bit is a feature also desired by the KVM community, and we
plan to work with them on implementing it.

Oren.
