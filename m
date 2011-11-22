Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758210Ab1KVUa2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 15:30:28 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:52333 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757832Ab1KVUa0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 15:30:26 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH] PM / Hibernation: Fix *massive* memory leak at early exits in hibernation
Date: Tue, 22 Nov 2011 21:33:13 +0100
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc10+; KDE/4.6.0; x86_64; ; )
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>, len.brown@intel.com,
        tj@kernel.org, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
References: <20111121173939.9486.38357.stgit@srivatsabhat.in.ibm.com> <201111212325.39330.rjw@sisk.pl> <20111122114549.GC32023@elf.ucw.cz>
In-Reply-To: <20111122114549.GC32023@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201111222133.13667.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, November 22, 2011, Pavel Machek wrote:
> On Mon 2011-11-21 23:25:39, Rafael J. Wysocki wrote:
> > On Monday, November 21, 2011, Srivatsa S. Bhat wrote:
> > > At some of the early exit points during hibernation (exiting either due
> > > to failure or after a successful hibernation test, the memory pre-allocated
> > > for hibernation is not freed up. And this is *very* serious, because, during
> > > pre-allocation, it could have allocated upto a few *gigabytes* of memory!
> > > And hence, if a hibernation fails or even if we run some hibernation tests
> > > using the 'pm_test' framework, the system is rendered unstable due to memory
> > > becoming signifantly lower. Fix this bug.
> > 
> > While the observation is valid, I'd prefer to do something like the patch
> > below.
> 
> The code slowly becomes goto maze :-(.
> 
> > @@ -357,12 +357,14 @@ int hibernation_snapshot(int platform_mo
> >  		 * successful freezer test.
> >  		 */
> >  		freezer_test_done = true;
> > -		goto Close;
> > +		goto Cleanup;
> >  	}
> >  
> >  	error = dpm_prepare(PMSG_FREEZE);
> > -	if (error)
> > -		goto Complete_devices;
> > +	if (error) {
> > +		dpm_complete(msg);
> > +		goto Cleanup;
> > +	}
> 
> Perhaps dpm_prepare should be changed to clean after itself in the
> error case? That is the normal convention AFAICT....

Yes, in a future patch.

Thanks,
Rafael
