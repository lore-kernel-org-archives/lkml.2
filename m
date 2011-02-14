Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751770Ab1BNHCx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 02:02:53 -0500
Received: from mga02.intel.com ([134.134.136.20]:47165 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751373Ab1BNHCv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 02:02:51 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,467,1291622400"; 
   d="scan'208";a="602364104"
From: "Dong, Chuanxiao" <chuanxiao.dong@intel.com>
To: Arnd Bergmann <arnd@arndb.de>
CC: "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "cjb@laptop.org" <cjb@laptop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "adrian.hunter@nokia.com" <adrian.hunter@nokia.com>
Date: Mon, 14 Feb 2011 15:01:35 +0800
Subject: RE: [PATCH v4 1/3]mmc: set max_discard_sectors value for mmc queue
Thread-Topic: [PATCH v4 1/3]mmc: set max_discard_sectors value for mmc queue
Thread-Index: AcvK31hqd3Ql8dJKT7ehcvzTnWanLABJyZXA
Message-ID: <5D8008F58939784290FAB48F5497519835964E1F58@shsmsx502.ccr.corp.intel.com>
References: <20110212062214.GB25519@intel.com>
 <201102120938.16626.arnd@arndb.de>
 <5D8008F58939784290FAB48F54975198358C2EF87A@shsmsx502.ccr.corp.intel.com>
 <201102121904.30944.arnd@arndb.de>
In-Reply-To: <201102121904.30944.arnd@arndb.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Arnd Bergmann [mailto:arnd@arndb.de]
> Sent: Sunday, February 13, 2011 2:05 AM
> To: Dong, Chuanxiao
> Cc: linux-mmc@vger.kernel.org; cjb@laptop.org; linux-kernel@vger.kernel.org;
> akpm@linux-foundation.org; adrian.hunter@nokia.com
> Subject: Re: [PATCH v4 1/3]mmc: set max_discard_sectors value for mmc queue
> 
> On Saturday 12 February 2011 11:42:51 Dong, Chuanxiao wrote:
> > > From: Arnd Bergmann [mailto:arnd@arndb.de]
> > > On Saturday 12 February 2011 07:22:14 Chuanxiao Dong wrote:
> > > > max_discard_sectors value is UINT_MAX which means kernel block layer can
> pass
> > > > down unlimited sectors to MMC driver to erase. But erasing so many sectors
> may
> > > > delay some other important I/O requests. This is not preferred.
> > > >
> > > > So use 'pref_erase' to set a suitable max_discard_sectors value for mmc
> queue to
> > > > avoid erasing too many sectors at one time.
> > > >
> > > > Signed-off-by: Chuanxiao Dong <chuanxiao.dong@intel.com>
> > >
> > > I'm not sure about this one. pref_erase on SDHC cards should be the
> *minimum*
> > > unit you can erase in one request, not the maximum. Erasing an arbitrary
> >
> > I found the comment in mmc_init_erase() function which explains the
> 'pref_erase':
> > 'pref_erase' is defined as a guide to limit erases to that size and alignment.
> > So I think it is not the minimum unit driver can erase, also not the maximum
> > erase unit. It just a guide erase size for driver which can avoid holding host
> > controller too long to response other I/O requests.
> 
> Ok, I see. Adrian introduced the function and the comment last year,
> maybe he can comment on this some more. For all cards I've seen,
> multi-AU erases on SDHC cards are really fast, though the standard
> clearly allows for very slow erases.
> 
> My feeling is that the function is suboptimal right now, because it assumes
> that one AU is the best size. If a card reports that it can erase
> many AUs quickly (large N_erase, small T_erase, relatively large T_offset),
> we should report that to the user.
> 
> > > number of allocation units on an SDHC card should complete almost instantly,
> > > because it only needs to update a single table with the allocation units.
> > >
> > > Discarding partial allocation units will take a lot longer, because the
> > > card then has to copy over the remaining blocks.
> >
> > Is discarding started when card is idle or right after erase command?
> > Can it cause some other I/O requests delayed?
> 
> As far as I can tell, most operations on the card are synchronous when it's
> writing. The erase command on a partial AU should not return until the
> remaining data is copied to a new location, so it will take some time, but
> physically the AU can be done in the background, if reading from it simply
> returns a zero buffer rather than accessing the old data. Write-after-erase
> might have to wait for the erase to complete, but good cards could also
> hide that.
Thanks, Arnd.
When I do trim with a 32GB eMMC card in my platform, sometimes I can get the 10s timeout errors but sometimes not. I am not much clear about the "discarding partial AU will take a lot longer". If this action is hide for driver, then I think from driver side, the UINT_MAX value for max_discard_sectors will be OK. But if this action sometimes need driver to wait for some hardware interrupt, then I think the UINT_MAX value is not preferred.
Arnd, have any suggestion of dealing this? What I thought is using other value instead of using UINT_MAX.

Thanks
Chuanxiao
