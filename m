Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752490Ab1BLSEw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Feb 2011 13:04:52 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:50447 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752300Ab1BLSEl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Feb 2011 13:04:41 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "Dong, Chuanxiao" <chuanxiao.dong@intel.com>
Subject: Re: [PATCH v4 1/3]mmc: set max_discard_sectors value for mmc queue
Date: Sat, 12 Feb 2011 19:04:30 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc2+; KDE/4.5.1; x86_64; ; )
Cc: "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "cjb@laptop.org" <cjb@laptop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "adrian.hunter@nokia.com" <adrian.hunter@nokia.com>
References: <20110212062214.GB25519@intel.com> <201102120938.16626.arnd@arndb.de> <5D8008F58939784290FAB48F54975198358C2EF87A@shsmsx502.ccr.corp.intel.com>
In-Reply-To: <5D8008F58939784290FAB48F54975198358C2EF87A@shsmsx502.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102121904.30944.arnd@arndb.de>
X-Provags-ID: V02:K0:gxawMIxIKV8JqCQ8AxLf2SJ5a9ydERJlGYjEhvLpkVL
 c0duJBBAk6QQ5S0Sq+ysDnl5hukksfGm0N8+GobBMzrVgsPA0Z
 pkvhEKFO1QIdv9XlBxlkVPR08Gi/DK5GMlgs3lYnJDKJq6s1Pf
 Kr0qVvP4kgVQt+vxNqZ43w4wWcIjY2QL2dWtcuno/3PWLLn+8d
 mOihgJtOJYWbU9cu8xaMg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 12 February 2011 11:42:51 Dong, Chuanxiao wrote:
> > From: Arnd Bergmann [mailto:arnd@arndb.de]
> > On Saturday 12 February 2011 07:22:14 Chuanxiao Dong wrote:
> > > max_discard_sectors value is UINT_MAX which means kernel block layer can pass
> > > down unlimited sectors to MMC driver to erase. But erasing so many sectors may
> > > delay some other important I/O requests. This is not preferred.
> > >
> > > So use 'pref_erase' to set a suitable max_discard_sectors value for mmc queue to
> > > avoid erasing too many sectors at one time.
> > >
> > > Signed-off-by: Chuanxiao Dong <chuanxiao.dong@intel.com>
> > 
> > I'm not sure about this one. pref_erase on SDHC cards should be the *minimum*
> > unit you can erase in one request, not the maximum. Erasing an arbitrary
>
> I found the comment in mmc_init_erase() function which explains the 'pref_erase':
> 'pref_erase' is defined as a guide to limit erases to that size and alignment.
> So I think it is not the minimum unit driver can erase, also not the maximum 
> erase unit. It just a guide erase size for driver which can avoid holding host 
> controller too long to response other I/O requests.

Ok, I see. Adrian introduced the function and the comment last year,
maybe he can comment on this some more. For all cards I've seen,
multi-AU erases on SDHC cards are really fast, though the standard
clearly allows for very slow erases.

My feeling is that the function is suboptimal right now, because it assumes
that one AU is the best size. If a card reports that it can erase
many AUs quickly (large N_erase, small T_erase, relatively large T_offset),
we should report that to the user.

> > number of allocation units on an SDHC card should complete almost instantly,
> > because it only needs to update a single table with the allocation units.
> >
> > Discarding partial allocation units will take a lot longer, because the
> > card then has to copy over the remaining blocks.
>
> Is discarding started when card is idle or right after erase command?
> Can it cause some other I/O requests delayed?

As far as I can tell, most operations on the card are synchronous when it's
writing. The erase command on a partial AU should not return until the
remaining data is copied to a new location, so it will take some time, but
physically the AU can be done in the background, if reading from it simply
returns a zero buffer rather than accessing the old data. Write-after-erase
might have to wait for the erase to complete, but good cards could also
hide that.

	Arnd
