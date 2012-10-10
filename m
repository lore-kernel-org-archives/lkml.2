Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757533Ab2JJXpH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 19:45:07 -0400
Received: from claw.goop.org ([74.207.240.146]:38172 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754784Ab2JJXpD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 19:45:03 -0400
X-Greylist: delayed 623 seconds by postgrey-1.27 at vger.kernel.org; Wed, 10 Oct 2012 19:45:03 EDT
Message-ID: <5076060D.1030101@goop.org>
Date: Wed, 10 Oct 2012 16:34:37 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: KY Srinivasan <kys@microsoft.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "andi@firstfloor.org" <andi@firstfloor.org>
Subject: Re: [PATCH 2/2] Drivers: hv: Add Hyper-V balloon driver
References: <1349654347-18337-1-git-send-email-kys@microsoft.com> <1349654386-18378-1-git-send-email-kys@microsoft.com> <1349654386-18378-2-git-send-email-kys@microsoft.com> <20121009124449.f54bf8cb.akpm@linux-foundation.org> <426367E2313C2449837CD2DE46E7EAF930A33CC4@SN2PRD0310MB382.namprd03.prod.outlook.com> <20121009181458.e59e7094.akpm@linux-foundation.org>
In-Reply-To: <20121009181458.e59e7094.akpm@linux-foundation.org>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/09/2012 06:14 PM, Andrew Morton wrote:
> On Wed, 10 Oct 2012 00:09:12 +0000 KY Srinivasan <kys@microsoft.com> wrote:
>
>>>> +		if (!pg) {
>>>> +			*alloc_error = true;
>>>> +			return i * alloc_unit;
>>>> +		}
>>>> +
>>>> +		totalram_pages -= alloc_unit;
>>> Well, I'd consider totalram_pages to be an mm-private thing which drivers
>>> shouldn't muck with.  Why is this done?
>> By modifying the totalram_pages, the information presented in /proc/meminfo
>> correctly reflects what is currently assigned to the guest (MemTotal).
> eh?  /proc/meminfo:MemTotal tells you the total memory in the machine. 
> The only thing which should change it after boot is memory hotplug. 
[...]
> Why on earth do balloon drivers do this?  If the amount of memory which
> is consumed by balloons is interesting then it should be exported via a
> standalone metric, not by mucking with totalram_pages.

Balloon drivers are trying to fake a form of page-by-page memory
hotplug.  When they allocate memory from the kernel, they're actually
giving the pages back to the hypervisor to redistribute to other
guests.  They reduce totalram_pages to try and reflect that the memory
is no longer the kernel (in Xen, at least, the pfns will no longer have
any physical page underlying them).

I agree this is pretty ugly; it would be nice to have some better
interface to indicate what's going on.  At one point I tried to use the
memory hotplug interfaces for larger-scale dynamic transfers of memory
between a domain and the host, but when I last looked at it, it was too
coarse grained and heavyweight to replace the balloon mechanism.

    J
