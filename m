Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751992Ab2APXhJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 18:37:09 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:53707 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751743Ab2APXhH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 18:37:07 -0500
Date: Mon, 16 Jan 2012 15:37:01 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Jerome Marchand <jmarchan@redhat.com>
cc: Andrew Jones <drjones@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org, mingo@elte.hu,
        david.woodhouse@intel.com, gregkh@suse.de, davem@davemloft.net,
        axboe@kernel.dk, holt@sgi.com, linux-arch@vger.kernel.org,
        linux@arm.linux.org.uk, hskinnemoen@gmail.com, egtvedt@samfundet.no,
        msalter@redhat.com, a-jacquiot@ti.com, starvik@axis.com,
        jesper.nilsson@axis.com, dhowells@redhat.com, takata@linux-m32r.org,
        geert@linux-m68k.org, yasutake.koichi@jp.panasonic.com,
        jonas@southpole.se, kyle@mcmartin.ca, deller@gmx.de,
        jejb@parisc-linux.org, chris@zankel.net, greg@kroah.com,
        davej@redhat.com, airlied@linux.ie, jkosina@suse.cz,
        mchehab@infradead.org, johannes@sipsolutions.net,
        linville@tuxdriver.com
Subject: Re: [PATCH] kconfig: untangle EXPERT and EMBEDDED
In-Reply-To: <4F1442C5.70500@redhat.com>
Message-ID: <alpine.DEB.2.00.1201161530170.16270@chino.kir.corp.google.com>
References: <1326295008-29795-1-git-send-email-drjones@redhat.com> <alpine.DEB.2.00.1201111353330.21755@chino.kir.corp.google.com> <201201120918.53026.arnd@arndb.de> <20120112101805.GA2375@turtle.usersys.redhat.com> <alpine.DEB.2.00.1201121259270.17287@chino.kir.corp.google.com>
 <20120113085125.GA2452@turtle.usersys.redhat.com> <alpine.DEB.2.00.1201130230320.15417@chino.kir.corp.google.com> <20120113122202.GB2452@turtle.usersys.redhat.com> <alpine.DEB.2.00.1201131318340.24089@chino.kir.corp.google.com> <4F1442C5.70500@redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Jan 2012, Jerome Marchand wrote:

> I don't see what your objections to this patch are. It actually does not
> change anything to CONFIG_EMBEDDED and 6a108a14fa35 didn't either.

Then you don't understand the context in which it was written.  
CONFIG_EMBEDDED was hijacked to allow certain options to be configurable 
that have nothing to do with embedded devices.  It was a dumping ground 
for any option that was non-standard.  So we decided that enough is enough 
and to actually give it a name that would imply you should know what 
you're turning on and off before you can configure it.

We also didn't want to break the millions of configs out in the wild that 
tune CONFIG_EMBEDDED, so we allowed it to select EXPERT in the meantime 
for backwards compatibility.  This allowed CONFIG_EMBEDDED to be extended 
in the future so that it could separate the options away from EXPERT that 
actually made sense for embedded devices to be aware of a configure.  At 
that point, it would be possible to remove the "select EXPERT" from 
CONFIG_EMBEDDED once all existing users become "depends on EXPERT || 
EMBEDDED", or possibly even just "depends on EMBEDDED" in rare cases where 
non-embedded users would never want to enable it.  (CONFIG_SLOB may be an 
example of the latter, but I'll leave that to the embedded world to 
decide.)

> For instance, Why would CONFIG_EXPERT disable by default some HID devices?
> I could understand why it is done for CONFIG_EMBEDDED, but certainly not
> for an general EXPERT option.
> 

Then this is a prime example that you've identified were it would make 
sense to have the default value be dependant on EMBEDDED rather than 
EXPERT.  Feel free to send a patch to the HID maintainers.

> >> This patch is actually attempting to make progress in the separation of
> >> the semantics for EXPERT and the old, insane EMBEDDED, which had the very
> >> loose semantics. That's why it's called "untangle EXPERT and EMBEDDED".
> >>
> 
> If EMBEDDED was insane before 6a108a14fa35, then it still was after, since
> nothing changed. EMBEDDED was just renamed EXPERT, and the "new" EMBEDDED
> option just selects EXPERT.
> 

Except now it's possible to decouple from EXPERT.  That's the goal that 
Andrew doesn't understand and he's fine with breaking everybody's config 
because they aren't defconfigs and there's no way such a thing would be 
merged.
