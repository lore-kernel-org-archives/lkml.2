Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762840Ab2DLVaO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 17:30:14 -0400
Received: from beauty.rexursive.com ([150.101.121.179]:43855 "EHLO
	beauty.rexursive.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754124Ab2DLVaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 17:30:13 -0400
Message-ID: <1334266210.2573.8.camel@shrek.rexursive.com>
Subject: Re: [PATCH v10]: Hibernation: fix the number of pages used for
 hibernate/thaw buffering
From: Bojan Smojver <bojan@rexursive.com>
To: Per Olofsson <pelle@debian.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org
Date: Fri, 13 Apr 2012 07:30:10 +1000
In-Reply-To: <4F870317.1030408@debian.org>
References: <1334052489.2178.9.camel@shrek.rexursive.com>
	 <b84d15d8-f35b-4296-927b-86a722541072@email.android.com>
	 <4F870317.1030408@debian.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-2.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-04-12 at 18:30 +0200, Per Olofsson wrote:
> Indeed. I think what you want is:
> 
> read_pages = min(low_free_pages(),
>                  nr_free_pages() - snapshot_get_image_size()) / 2; 

I was thinking more like this:
----------------------
unsigned long read_pages = 0;

[...]

if (low_free_pages() > snapshot_get_image_size())
       read_pages = (low_free_pages() - snapshot_get_image_size()) / 2;
read_pages = clamp_val(read_pages, LZO_MIN_RD_PAGES, LZO_MAX_RD_PAGES);
----------------------

Where LZO_MIN_RD_PAGES and LZO_MAX_RD_PAGES are set to 1024 and 8192,
respectively (this was picked empirically).

Because we don't really know how many highmem pages are in the image
(this is figured out by prepare_image() function, half way through
reading the image - so way after this calculation is done), we assume
the worst case scenario. And that is that there are no highmem pages in
the image.

Given that we cannot use pages from highmem for buffers anyway, the
above should be careful enough. Of course, there is still some
possibility of running out of pages, but the kernel is usually in a
pretty good shape memory-wise on image load, so we should be able to
squeeze a few MBs out of it, at least.

-- 
Bojan

