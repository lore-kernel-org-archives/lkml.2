Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753196Ab1HBXha (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 19:37:30 -0400
Received: from smtp-out.google.com ([216.239.44.51]:58859 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751759Ab1HBXhZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 19:37:25 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:from:date:
	message-id:subject:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=K9uDmyGgN3kQQQgU5L9gr9cWS4h1KEmvAABZA6Kmx+k67x62s2DpKR3sRgbgapMMl
	lSbjygtLlrX24fhtbZU1w==
MIME-Version: 1.0
In-Reply-To: <CAGTjWtC-iGP1RGbE8R9EGEM9X_YeA+2wahmNtcNzcU=sb7EBbw@mail.gmail.com>
References: <20110719203843.646.73383.stgit@mike2.sea.corp.google.com>
 <20110719203853.646.50974.stgit@mike2.sea.corp.google.com>
 <20110729204529.GB3207@stro.at> <CAGTjWtCYb0NOBFsMxWKWEwN-pdOD1fqimHco3nk_N-tKQvxdyQ@mail.gmail.com>
 <20110802210912.GB20986@stro.at> <CAGTjWtAyCZ9fyBeEcsrSmpzK4Lgae5uyHCfO2LExeYLSrx+4jg@mail.gmail.com>
 <CABV1ukGS8RN9BGC-TDB5L=yOUc1cUB3OuspGXKGwdwGtCvrZQg@mail.gmail.com> <CAGTjWtC-iGP1RGbE8R9EGEM9X_YeA+2wahmNtcNzcU=sb7EBbw@mail.gmail.com>
From: Mike Waychison <mikew@google.com>
Date: Tue, 2 Aug 2011 16:37:03 -0700
Message-ID: <CAGTjWtC+e185XcWskviA7B1T=AcdK5kVkpuZkBC-r8xpgcZ2KA@mail.gmail.com>
Subject: Re: [PATCH v1 2/2] run-init: Add drop_capabilities support.
To: "Andrew G. Morgan" <agm@google.com>
Cc: Maximilian Attems <max@stro.at>, Eric Northup <digitaleric@google.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, "H. Peter Anvin" <hpa@zytor.com>,
        Eric Paris <eparis@parisplace.org>, klibc@zytor.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 2, 2011 at 3:56 PM, Mike Waychison <mikew@google.com> wrote:
> On Tue, Aug 2, 2011 at 3:50 PM, Andrew G. Morgan <agm@google.com> wrote:
>> Which part of the version check are you dropping?
>
> The version check in the patch I posted is used when access to
> /proc/sys/kernel/usermodehelper/{bset|inheritable} files fails with
> ENOENT (which looking closer is broken in the patch I sent as the
> wrong pathnames are used).
>
> Given that I'm only planning on using this on kernels that are v3.0 or
> have this code back ported anyway, and the fact the option is new, I'm
> going to try changing this over to _always_ failing like in all the
> other *something went wrong enforcing the security policy* paths.

Sigh.  Not sure how I missed this in the first place..    we always
unmount /proc before invoking run_init() from kinit's main.

To add to the confusion, mount_sys_fs() returns 0 if the mountpoint is
already present, which causes kinit to bail, while we continue merrily
if the mount() call fails -- oops.

Perhaps the right approach is to not drop the effective and permitted
masks as Andrew pointed out, and do all this from kinit, not from
run-init while /proc is mounted?

>
>>
>> Also, I'm not clear you need/want to drop the permitted/effective
>> bits. All that will survive the exec() are the inheritable bits.
>
> Okay.  Will drop these.
>
>>
>> Cheers
>>
>> Andrew
>>
>> On Tue, Aug 2, 2011 at 2:42 PM, Mike Waychison <mikew@google.com> wrote:
>>> On Tue, Aug 2, 2011 at 2:09 PM, Maximilian Attems <max@stro.at> wrote:
>>>> On Fri, 29 Jul 2011, Mike Waychison wrote:
>>>>
>>>>> On Fri, Jul 29, 2011 at 1:45 PM, Maximilian Attems <max@stro.at> wrote:
>>>>> > On Tue, 19 Jul 2011, Mike Waychison wrote:
>>>>> >
>>>>> >> This patch adds the ability to run-init to allow the dropping of
>>>>> >> POSIX capabilities.
>>>>> >>
>>>>> >> This works by adding a "-d" flag to run-init, which takes a comma
>>>>> >> separated list of capability names that should be dropped right before
>>>>> >> exec'ing the real init binary.
>>>>> >>
>>>>> >> kinit is also modified by this change, such that it understands the same
>>>>> >> argument when prepended with "drop_capabilities=" on the kernel command
>>>>> >> line.
>>>>> >>
>>>>> >> When processing capabilities to drop, CAP_SETPCAP is special cased to be
>>>>> >> dropped last, so that the order that capabilities are given does not
>>>>> >> cause dropping of later enumerated capabilities to fail if it is listed
>>>>> >> early on.
>>>>> >>
>>>>> >> Dropping of capabilities happens in three parts.  We explicitly drop the
>>>>> >> capability from init's inherited, permitted and effective masks.  We
>>>>> >> also drop the capability from the bounding set using PR_CAPBSET_DROP.
>>>>> >> Lastly, if available, we drop the capabilities from the bset and
>>>>> >> inheritted masks exposed at /proc/sys/kernel/usermodehelper if available
>>>>> >> (introduced in v3.0.0).
>>>>> >
>>>>> > hmm as 3.0 is out, I don't think we need more backward compatibility.
>>>>> > do you have a strong arg for it?
>>>>> > especially since this is an *optional* calling arg I really don't see
>>>>> > the need of that backward crap.
>>>>>
>>>>> I'd like to keep it for the time being. I'm still building both 2.6.34
>>>>> and 2.6.39 kernels at the moment, though I can maintain these last few
>>>>> compatibility bits in-house if that makes it easier for you.
>>>>
>>>> you include anyway linux/version.h, would build disabling help you?
>>>> that way that macro doesn't need duplicating.
>>>>
>>>
>>> For correctness sake, I think it's still a runtime check thing
>>> (consider the case of an image that is reused between kernel builds).
>>>
>>> Reflecting on it a bit more though, I'd be okay if we removed the
>>> version check altogether and just made it warn if the file isn't
>>> present.
>>>
>>
>
