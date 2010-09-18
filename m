Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753847Ab0IRAhL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 20:37:11 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:51625 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752244Ab0IRAhJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 20:37:09 -0400
From: Kevin Hilman <khilman@deeprootsystems.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Nishanth Menon <nm@ti.com>,
        linux-arm <linux-arm-kernel@lists.infradead.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Phil Carmody <ext-phil.2.carmody@nokia.com>,
        linux-pm <linux-pm@lists.linux-foundation.org>,
        Matthew Garrett <mjg@redhat.com>, Len Brown <len.brown@intel.com>,
        linux-omap <linux-omap@vger.kernel.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [linux-pm] [PATCH] opp: introduce library for device-specific OPPs
Organization: Deep Root Systems, LLC
References: <1284686973-13993-1-git-send-email-nm@ti.com>
	<20100917153643.GC29739@sirena.org.uk> <4C938EE2.1010307@ti.com>
	<20100917155937.GB29596@rakim.wolfsonmicro.main>
Date: Fri, 17 Sep 2010 17:37:06 -0700
In-Reply-To: <20100917155937.GB29596@rakim.wolfsonmicro.main> (Mark Brown's
	message of "Fri, 17 Sep 2010 16:59:37 +0100")
Message-ID: <87hbhnq43x.fsf@deeprootsystems.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[trimmed Cc list a bit, as vger bounced my last reply due to header too long]

Mark Brown <broonie@opensource.wolfsonmicro.com> writes:

> On Fri, Sep 17, 2010 at 10:53:06AM -0500, Nishanth Menon wrote:
>> Mark Brown had written, on 09/17/2010 10:36 AM, the following:
>
>> >It might be clearer to use some term other than enabled in the code -
>> >when reading I wasn't immediately sure if enabled meant that it was
>> >available to be selected or if it was the active operating point.  How
>> >about 'allowed' (though I'm not 100% happy with that)?
>
>> ;).. The opp is enabled or disabled if it is populated, it is
>> implicit as being available but not enabled- how about active? this
>> would change the opp_enable/disable functions to opp_activate,
>> opp_deactivate..
>
>> Recommendations folks?
>
> The enable/disable thing wasn't so noticable in the API itself, it was
> in the data structures that I found it confusing - the core has a
> different idea about what's going on with the system as a whole compared
> to the decision that an individual device is taking.

Can you clarify your confusion here?  I don't follow the problem you're
raising.

The enabled flag in the internal data structure is set to true when
opp_enable() is called and set to false when opp_disable() is called.
I'm not sure

At least as we're currently using it, this API has know knowlege of what
OPP is currently active on the system.  IOW, it has no idea what the
current frequency/voltage a given device is set to.  It's intended more
like an OPP database with some convience functions to search through the
OPPs and to make OPPs available (or not.)  The users of this API (in our
case, CPUfreq and voltage scaling code) are the ones which
keep track of which OPP is actually in use.

As I write this, I agree with what Phil pointed out; that 'available' is
probably the right name for this flag, instead of 'enabled.'

>> >When reading the description I'd expected to see some facility to
>> >trigger selection of an active operating point in the library (possibly
>> >as a separate call since you might have a bunch of operating points
>> >being updated in quick succession) but it looks like that needs to be
>> >supplied externally at the minute?
>
>> The intent is we use the opp_search* functions to pick up the opp
>> and enable/activate it and disable/deactivate it.
>
> Sure, I get that bit.  What I meant was that I was expecting something
> that would say that changes had been made to the enabled/disabled sets
> and that it'd be a good idea to rescan, especially for cases where the
> devices change their requirements but the OPPs need to be done over a
> larger block.

I guess you're thinking of notifiers, so if the list of available OPPs
changes, a driver could (re)search to see if a more optimal OPP was
available?

Certainly sounds possible, but not sure how useful in practice.  OPP
change decisions are not very often, so any OPP database updates may not
affect a device OPP change currently in progress, but would take effect
the next time that device makes an OPP change.

Either way, this is something that could easily be added if it seems
useful.

Kevin
