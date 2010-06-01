Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751514Ab0FAAZZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 20:25:25 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:47458 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049Ab0FAAZY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 20:25:24 -0400
MIME-Version: 1.0
Message-ID: <4510198c-1562-4766-9cdc-a1df70b14910@default>
Date: Mon, 31 May 2010 17:23:52 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: ngupta@vflare.org
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, jeremy@goop.org,
       hugh.dickins@tiscali.co.uk, JBeulich@novell.com, chris.mason@oracle.com,
       kurt.hackel@oracle.com, dave.mccracken@oracle.com, npiggin@suse.de,
       akpm@linux-foundation.org, riel@redhat.com, avi@redhat.com,
       pavel@ucw.cz, konrad.wilk@oracle.com
Subject: RE: [PATCH V2 0/4] Frontswap (was Transcendent Memory): overview
References: <20100528174020.GA28150@ca-server1.us.oracle.com>
 <4C02AB5A.5000706@vflare.org> <a38d5a97-1517-46c4-9b2f-27e16aba58f2@default
 4C040981.8030002@vflare.org>
In-Reply-To: <4C040981.8030002@vflare.org>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 1.5.1.5.2  (401224) [OL
 12.0.6514.5000]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090203.4C045354.00BD:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Nitin Gupta [mailto:ngupta@vflare.org]

> frontswap is a particular use case of zram disks. However, we still
> need to work on some issues with zram:
>  - zram cannot return write/put failures for arbitrary pages. OTOH,
> frontswap can consult host before every put and may forward pages to
> in-guest swap device when put fails.
>  - When a swap slot is freed, the notification from guest does
> not reach zram device(s) as exported from host. OTOH, frontswap calls
> frontswap_flush() which frees corresponding page from host memory.
>  - Being a block device, it is potentially slower than frontswap
> approach. But being a generic device, its useful for all kinds
> of guest OS (including windows etc).

Hi Nitin --

This is a good list (not sure offhand it is complete or not) of
the key differences between zram and frontswap.  Unless/until
zram solves each of these issues -- which are critical to the
primary objective of frontswap (namely intelligent overcommit) --
I simply can't agree that frontswap is a particular use case
of zram.  Zram is just batched asynchronous I/O to a fixed-size
device with a bonus of on-the-fly compression.  Cool, yes.
Useful, yes.  Useful in some cases in a virtualized environment,
yes.  But a superset/replacement of frontswap, no.

> Yes, zram cannot return write/put failure for arbitrary pages but other
> than that what additional benefits does frontswap bring? Even with
> frontswap,
> whatever pages are once given out to hypervisor just stay there till
> guest
> reads them back. Unlike cleancache, you cannot free them at any point.
> So,
> it does not seem anyway more flexible than zram.

The flexibility is that the hypervisor can make admittance
decisions on each individual page... this is exactly what
allows for intelligent overcommit.  Since the pages "just
stay there until the guest reads them back", the hypervisor
must be very careful about which and how many pages it accepts
and the admittance decisions must be very dynamic, depending
on a lot of factors not visible to any individual guest
and not timely enough to be determined by the asynchronous
"backend I/O" subsystem of a host or dom0.

Thanks,
Dan
