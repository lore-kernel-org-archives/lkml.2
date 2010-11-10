Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756405Ab0KJUNM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 15:13:12 -0500
Received: from imr4.ericy.com ([198.24.6.8]:39805 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756188Ab0KJUNL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 15:13:11 -0500
Date: Wed, 10 Nov 2010 12:12:20 -0800
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Henrik Rydberg <rydberg@euromail.se>
CC: Jean Delvare <khali@linux-fr.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] hwmon: (applesmc) Fix checkpatch errors
Message-ID: <20101110201220.GA3084@ericsson.com>
References: <1289415200-4928-1-git-send-email-guenter.roeck@ericsson.com>
 <4CDAE9D7.3060007@euromail.se>
 <20101110193930.GA31650@ericsson.com>
 <4CDAF8E4.7030609@euromail.se>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4CDAF8E4.7030609@euromail.se>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 10, 2010 at 02:56:20PM -0500, Henrik Rydberg wrote:
> >>> @@ -977,7 +975,11 @@ static ssize_t applesmc_key_at_index_show
> 
> >>>  static ssize_t applesmc_key_at_index_store(struct device *dev,
> >>>  	struct device_attribute *attr, const char *sysfsbuf, size_t count)
> >>>  {
> >>> -	key_at_index = simple_strtoul(sysfsbuf, NULL, 10);
> >>> +	unsigned long newkey;
> >>> +
> >>> +	if (strict_strtoul(sysfsbuf, 10, &newkey) < 0)
> >>> +		return -EINVAL;
> >>> +	key_at_index = newkey;
> >>
> >>
> >> Crash alert - key_at_index is not range checked, and the remake uses this value
> >> as an array index...
> >>
> > Good that I made this change ;). I'll add the check and re-send.
> 
> 
> Indeed! The downside of remakes... sorry about that. :-)
> 
Happens.

> I guess the change should go into patch 4 already? There is also the option to
> put the bounds check in applesmc_get_entry_by_index, but I like the simplicity
> of "|| newkey >= smcreg.key_count".
> 
I don't like the idea of putting the check into applesmc_get_entry_by_index().
Let me see if I can merge it into patch #4. If not, I'll keep it in my patch
for simplicity.

> > This points to another problem, though. You allocate key_count entries,
> > ie cache[0]..cache[key_count-1]. Yet, the key searches are from 0..key_count,
> > ie span key_count+1 entries. Is that another problem ?
> 
> >
> 
> > Seems to me you would either have to allocate key_count+1 entries, or terminate
> > the search at key_count - 1. Not sure which one would be correct. Let me know,
> > and I'll update the affected patch(es).
> 
> 
> If you are referring to the lower and upper bound functions, those use the
> one-past-the-last-element convention, so it is actually still 0..key_count - 1.
> I stayed very close to the stl reference implementation, which relies on the
> fact that when begin != end, (begin + (end - begin) / 2) < end.
> 
Ok, you are right - I was concerned about applesmc_get_upper_bound() returning
smcreg.key_count, but that is ok, since that value is never used to actually
retrieve a key.

Thanks,
Guenter
