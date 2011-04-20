Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752123Ab1DTIIy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 04:08:54 -0400
Received: from smtpout.karoo.kcom.com ([212.50.160.34]:58637 "EHLO
	smtpout.karoo.kcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751360Ab1DTIIw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 04:08:52 -0400
X-Greylist: delayed 588 seconds by postgrey-1.27 at vger.kernel.org; Wed, 20 Apr 2011 04:08:51 EDT
X-IronPort-AV: E=Sophos;i="4.64,244,1301871600"; 
   d="scan'208";a="762836380"
MIME-Version: 1.0
X-Priority: Normal
X-Mailer: AtMail PHP 5.62
Message-ID: <42558.1303286300@jupiter.eclipse.co.uk>
To: <linux-kernel@vger.kernel.org>
Reply-To: rwhitton@iee.org
Content-Type: text/plain; charset="utf-8"
X-Origin: 213.121.168.130
X-Atmail-Account: rwhitton@jupiter.eclipse.co.uk
Date: Wed, 20 Apr 2011 08:58:20 +0100
Subject: Background memory scrubbing
From: Robert Whitton <rwhitton@iee.org>
Cc: <rwhitton@iee.org>
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have a home grown module that performs background memory scrubbing to eliminate single bit memory errors before they become a problem. This has been working in the 2.6.26 kernels for sometime (it is specifically targeted at the AMD64 PC architecture). I have now moved to the 2.6.32 kernel and it fails with "unable to handle kernel paging request" after a couple of minutes. The code works in summary as follows in a kernel thread...

for each PFN from 256 to the highest valid PFN
{
  if (pfn_valid(PFN))
  {
    page = pfn_to_page(PFN)
    va = kmap(page)
    atomic_scrub(va, PAGE_SIZE)
    kunmap(page)
  }

  sleep(for_a_while)
}


This code works absolutely fine up to a short distance beyond the 16MB boundary (specifically it seems to always fail on my hardware at PFN 4105). At this point despite the fact that kmap returns a valid virtual address (and it is the virtual address that I expect - 0xffff880001009000) I get the kernel oops - "unable to handle kernel paging request".

My immediate thought was to check the kernel page tables and avoid those pages that are marked as not present or read only however it appears that init_mm and pgd_offset_k have both been deprecated. I have also looked at page->flags but I've found that the flags for the first page that fails are exactly the same as for the previous page that works absolutely fine so I don't appear to be able to use page->flags to make a valid distinction.

So I'm looking for any hints on how to fix the original code i.e. how can the I sensibly detect "a priori" if a PFN/page has a valid mapping in the kernel page tables such that I can read/write to that page via a kmap(ped) virtual address. Alternatively since init_mm and pgd_offset_k have been deprecated how can I gain access to the kernel page tables?

Thanks in advance for any help.

Rob


(please CC me in on any responses)




