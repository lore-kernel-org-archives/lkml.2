Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751720Ab2DCHPt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 03:15:49 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:58398 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750838Ab2DCHPs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 03:15:48 -0400
Date: Tue, 3 Apr 2012 09:15:43 +0200
From: Ingo Molnar <mingo@kernel.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Bruno =?iso-8859-1?Q?Pr=E9mont?= <bonbons@linux-vserver.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] Prevent crash on missing sysfs attribute group
Message-ID: <20120403071543.GA17502@gmail.com>
References: <20120402162716.4c93bfd3@pluto.restena.lu>
 <20120402165036.2bc987ad@pluto.restena.lu>
 <m17gxyklfm.fsf@fess.ebiederm.org>
 <20120402213440.49e9de74@neptune>
 <1333401898.2960.78.camel@laptop>
 <1333403193.2960.80.camel@laptop>
 <20120403060252.GA27084@gmail.com>
 <20120403081735.78ca3bb3@pluto.restena.lu>
 <m1d37pgugy.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <m1d37pgugy.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Eric W. Biederman <ebiederm@xmission.com> wrote:

> Nacked-by: "Eric W. Biederman" <ebiederm@xmission.com>
> 
> Bruno Prémont <bonbons@linux-vserver.org> writes:
> 
> > Prevent kernel from crashing when a device is being registered with sysfs
> > but has no (aka NULL) group attributes, but warn about it so calling path
> > can get fixed.
> 
> The idea is reasonable but the implementation is horrible.
> 
> >> Will do - but the underlying generic bug should be fixed as 
> >> well: we must not crash just because some attributes are missing 
> >> in a rarely used sub-driver ...
> >> 
> >> We should WARN_ON(), etc. - but not crash.
> 
> FIX perf to include sanity checks.

Huh, so put repeated, duplicated, inconsistently applied sanity 
checks into dozens of sysfs attribute using kernel subsystems?

Major FAIL, dude.

> Anything we do in sysfs is just pointless because perf was 
> clever and the offender did not show up in the backtrace.
> 
> Right now perf is so bad we just waste everyone's time.
>
> > Greg, is this ok for you or should the check be moved out to 
> > calling internal_create_group()?
> 
> Please put changes in internal_create_group where all of the 
> rest of the checks are.

So you *do* agree that a check in a generic place is useful 
after all? ;-)

> We should do something like:
> if (!grp->attrs) {
> 	WARN(1, "sysfs: idiot subsystem did not include attrs for group: %s/%s\n"
>         	kobj->name, grp->name?"":grp->name);
> 	return -EINVAL;
> }
>
> As it stands your patch is horrible it leaves sysfs in an 
> inconsistent state.  Creating the directory and leaving it 
> there.  Not returning an error code.  It looks like there are 
> all kinds of weird problems that removing the group or 
> updating the group could get into if we go with your patch.

This is actually a sensible suggestion. Bruno, mind updating 
your patch to do something like this? Assuming Greg agrees with 
putting the check/warning there.

Eric's rant about putting sanit checks at every usage site is 
just crazy talk.

Thanks,

	Ingo
