Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932705Ab2HINyX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 09:54:23 -0400
Received: from mga01.intel.com ([192.55.52.88]:30930 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932262Ab2HINyV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 09:54:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,739,1336374000"; 
   d="scan'208";a="195441380"
Date: Thu, 9 Aug 2012 21:54:16 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Dave Peterson <dsp@llnl.gov>, kernel-janitors@vger.kernel.org,
        Doug Thompson <dougthompson@xmission.com>, linux-edac@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-ID: <20120809135416.GA13100@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: possible double free in edac_mc_alloc()
Reply-To: 
User-Agent: Heirloom mailx 12.5 6/20/10

Hi,

coccinelle warns about:

+ drivers/edac/edac_mc.c:429:9-23: ERROR: reference preceded by free on line 429

and that line does look strange: the 'i' seems like a temporary value
used in previous loops, and it won't change at all in the current
loop. Which means the same mci->csrows[i] get freed once and again.
It might also do double free for the previous kfree(csr) line.

vim +429 drivers/edac/edac_mc.c

   416         if (mci->dimms) {
   417                 for (i = 0; i < tot_dimms; i++)
   418                         kfree(mci->dimms[i]);
   419                 kfree(mci->dimms);
   420         }
   421         if (mci->csrows) {
   422                 for (chn = 0; chn < tot_channels; chn++) {
   423                         csr = mci->csrows[chn];
   424                         if (csr) {
   425                                 for (chn = 0; chn < tot_channels; chn++)
   426						kfree(csr->channels[chn]);
   427					kfree(csr);
   428				}
 > 429				kfree(mci->csrows[i]);
   430			}
   431			kfree(mci->csrows);
   432		}

---
0-DAY kernel build testing backend         Open Source Technology Centre
Fengguang Wu <wfg@linux.intel.com>                     Intel Corporation
