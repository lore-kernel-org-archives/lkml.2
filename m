Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757281Ab2JJBNU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 21:13:20 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57462 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754519Ab2JJBNR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 21:13:17 -0400
Date: Tue, 9 Oct 2012 18:14:58 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: KY Srinivasan <kys@microsoft.com>
Cc: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "andi@firstfloor.org" <andi@firstfloor.org>
Subject: Re: [PATCH 2/2] Drivers: hv: Add Hyper-V balloon driver
Message-Id: <20121009181458.e59e7094.akpm@linux-foundation.org>
In-Reply-To: <426367E2313C2449837CD2DE46E7EAF930A33CC4@SN2PRD0310MB382.namprd03.prod.outlook.com>
References: <1349654347-18337-1-git-send-email-kys@microsoft.com>
	<1349654386-18378-1-git-send-email-kys@microsoft.com>
	<1349654386-18378-2-git-send-email-kys@microsoft.com>
	<20121009124449.f54bf8cb.akpm@linux-foundation.org>
	<426367E2313C2449837CD2DE46E7EAF930A33CC4@SN2PRD0310MB382.namprd03.prod.outlook.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Oct 2012 00:09:12 +0000 KY Srinivasan <kys@microsoft.com> wrote:

> > > +		if (!pg) {
> > > +			*alloc_error = true;
> > > +			return i * alloc_unit;
> > > +		}
> > > +
> > > +		totalram_pages -= alloc_unit;
> > 
> > Well, I'd consider totalram_pages to be an mm-private thing which drivers
> > shouldn't muck with.  Why is this done?
> 
> By modifying the totalram_pages, the information presented in /proc/meminfo
> correctly reflects what is currently assigned to the guest (MemTotal).

eh?  /proc/meminfo:MemTotal tells you the total memory in the machine. 
The only thing which should change it after boot is memory hotplug. 

Modifying it in this manner puts the statistic into a state know as
"wrong".  And temporarily modifying it in this fashion will cause the
tremendous amount of initialisation code which relies upon
totalram_pages for sizing to also enter the "wrong" state.

Why on earth do balloon drivers do this?  If the amount of memory which
is consumed by balloons is interesting then it should be exported via a
standalone metric, not by mucking with totalram_pages.

