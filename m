Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753199Ab2DPLCi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 07:02:38 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:34071 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753037Ab2DPLCh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 07:02:37 -0400
Date: Mon, 16 Apr 2012 13:02:22 +0200
From: Borislav Petkov <bp@amd64.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Borislav Petkov <bp@amd64.org>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 01/13] edac: Create a dimm struct and move the labels
 into it
Message-ID: <20120416110222.GA308@aftab>
References: <1333039546-5590-1-git-send-email-mchehab@redhat.com>
 <1333039546-5590-2-git-send-email-mchehab@redhat.com>
 <20120330105048.GA30876@aftab>
 <4F8BDB3D.2020808@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F8BDB3D.2020808@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 16, 2012 at 05:41:33AM -0300, Mauro Carvalho Chehab wrote:
> This is not a double loop.

But it is, actually.

Let's look at the code:

        /* setup index and various internal pointers */
        mci->mc_idx = edac_index;
        mci->csrows = csi;
        mci->dimms  = dimm;
        mci->pvt_info = pvt;
        mci->nr_csrows = nr_csrows;

        for (row = 0; row < nr_csrows; row++) {					<-- A1
                csrow = &csi[row];
                csrow->csrow_idx = row;
                csrow->mci = mci;
                csrow->nr_channels = nr_chans;
                chp = &chi[row * nr_chans];
                csrow->channels = chp;

                for (chn = 0; chn < nr_chans; chn++) {				<-- B1
                        chan = &chp[chn];
                        chan->chan_idx = chn;
                        chan->csrow = csrow;
                }
        }

        /*
         * By default, assumes that a per-csrow arrangement will be used,
         * as most drivers are based on such assumption.
         */
        dimm = mci->dimms;
        for (row = 0; row < mci->nr_csrows; row++) {				<-- A2
                for (chn = 0; chn < mci->csrows[row].nr_channels; chn++) {	<-- B2
                        mci->csrows[row].channels[chn].dimm = dimm;
                        dimm->csrow = row;
                        dimm->csrow_channel = chn;
                        dimm++;
                        mci->nr_dimms++;
                }
        }

So the lines tagged with A1 and A2 iterate over the nr_csrows, while
lines tagged with B1 and B2 iterate over nr_chans. In B2, loop termination is

	mci->csrows[row].nr_channels

which is assigned in the first loop above to

	csrow->nr_channels = nr_chans

In B1, it is simply nr_chans.

So how about we merge those two:

	...
	dimm = mci->dimms;

        for (row = 0; row < nr_csrows; row++) {					<-- A1
                csrow = &csi[row];
                csrow->csrow_idx = row;
                csrow->mci = mci;
                csrow->nr_channels = nr_chans;
                chp = &chi[row * nr_chans];
                csrow->channels = chp;

                for (chn = 0; chn < nr_chans; chn++) {				<-- B1
                        chan = &chp[chn];
                        chan->chan_idx = chn;
                        chan->csrow = csrow;

			 /* second loop */
                        csrow->channels[chn].dimm = dimm;
                        dimm->csrow = row;
                        dimm->csrow_channel = chn;
                        dimm++;
                        mci->nr_dimms++;
                }
        }

So it is only 5 lines of code instead of another loop.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
