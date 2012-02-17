Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755111Ab2BQDzq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 22:55:46 -0500
Received: from mail-qw0-f53.google.com ([209.85.216.53]:62808 "EHLO
	mail-qw0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752224Ab2BQDzp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 22:55:45 -0500
MIME-Version: 1.0
In-Reply-To: <201202160007.33131.rjw@sisk.pl>
References: <201202070200.55505.rjw@sisk.pl>
	<201202150022.26072.rjw@sisk.pl>
	<CAMP5XgfgZphvsoFr62=oNoDUxXSeRXmu21Co3fGWXhZ17DgO_A@mail.gmail.com>
	<201202160007.33131.rjw@sisk.pl>
Date: Thu, 16 Feb 2012 19:55:44 -0800
Message-ID: <CAMP5XgcTWNVPPNjZ9OXx1POokaOuRaYmGbD9Sfa1W7J3o2NdYA@mail.gmail.com>
Subject: Re: [RFC][PATCH 0/8] PM: Implement autosleep and "wake locks"
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>, markgross@thegnar.org,
        Matthew Garrett <mjg@redhat.com>, Greg KH <gregkh@linuxfoundation.org>,
        John Stultz <john.stultz@linaro.org>,
        Brian Swetland <swetland@google.com>, Neil Brown <neilb@suse.de>,
        Alan Stern <stern@rowland.harvard.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/2/15 Rafael J. Wysocki <rjw@sisk.pl>:
> On Wednesday, February 15, 2012, Arve Hjønnevåg wrote:
>> 2012/2/14 Rafael J. Wysocki <rjw@sisk.pl>:
>> > On Tuesday, February 14, 2012, Arve Hjønnevåg wrote:
>> >> On Mon, Feb 6, 2012 at 5:00 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> >> ...
>> >> but the wake-source timeout feature has some bugs or incompatible apis. An
>> >> init api would also be useful for embedding wake-sources in other data
>> >> structures without adding another memory allocation. Your patch to
>> >> move the spinlock init to wakeup_source_add still require the struct
>> >> to be zero initialized and the name set manually.
>> >
>> > That should be easy to fix.  What about the appended patch?
>> >
>>
>> That works, but I still have to call more than one function before I
>> can use the wakeup-source (wakeup_source_init and wakeup_source_add)
>> and more than one function before I can free it (__pm_relax,
>> wakeup_source_remove and wakeup_source_drop). Is there any reason to
>> keep these separate?
>
> Yes, there is.  I think that wakeup_source_create/_destroy() should
> use the same initialization functions internally that will be used for
> externally allocated wakeup sources (to make sure that all wakeup source
> objects are initialized in exactly the same way).
>

I agree with that, but is it useful to export these helper functions?

>> Also, not copying the name when the caller provides the memory for the
>> wakeup-source would be a closer match to the wakelock api. Most of our
>> wakelocks pass a string constant as the name, and making a copy of
>> that string is not useful. wake_lock_init is also safe to call from
>> atomic context, but I don't know if anyone relies on this.
>
> OK, below is another go.  It doesn't copy the name if wakeup_source_init() is
> used (which also does the _add this time).  I think, though, that copying
> the name is generally safer, because someone might use wakeup_source_init()
> with the name string allocated on the stack or otherwise temporary, which would
> be a bug with the new version.
>

I prefer this version. I have not seen a bug where someone passed a
temporary as the wakelock name, I assume since this will show up
immediately in the stats file.

-- 
Arve Hjønnevåg
