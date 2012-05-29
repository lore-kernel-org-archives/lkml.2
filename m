Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753219Ab2E2OCb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 10:02:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51571 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751810Ab2E2OC3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 10:02:29 -0400
Message-ID: <4FC4D6E2.9060501@redhat.com>
Date: Tue, 29 May 2012 11:02:10 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Aristeu Rozanski <arozansk@redhat.com>,
        Doug Thompson <norsk5@yahoo.com>, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH] RAS: Add a tracepoint for reporting memory controller
 events
References: <1337358773-6919-38-git-send-email-mchehab@redhat.com> <1337854460-25191-1-git-send-email-mchehab@redhat.com> <20120524105604.GC27063@aftab.osrc.amd.com> <4FBE5E1D.7070804@redhat.com> <20120524164554.GM27063@aftab.osrc.amd.com> <4FBE7755.2080301@redhat.com> <20120529115851.GB29157@aftab.osrc.amd.com>
In-Reply-To: <20120529115851.GB29157@aftab.osrc.amd.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 29-05-2012 08:58, Borislav Petkov escreveu:
> On Thu, May 24, 2012 at 03:00:53PM -0300, Mauro Carvalho Chehab wrote:

<ironic comments skipped>
 
>> the address and address mask is needed, as most memory controllers can't point
>> to a single address, because the register that stores the address doesn't have
>> enough bits to store the full content of the instruction pointer register, or because
>> of some other internal device issues.
>>
>> So, two different "addresses" could atually point to the same group of transistors
>> inside a DIMM.
>>
>> Also, higher values of grains may affect the error statistics. For example, i3200_edac
>> driver has a grain that can be 64 MB, while other devices have a grain of 1.
> 
> I think you mean
> 
> #define I3200_TOM_SHIFT         26      /* 64MiB grain */

> 
> which is the Top-Of-Memory shift value. How is that grain in the sense of error
> granularity I can't fathom.
> 

It seems you were unable to read the comments at the function that fills dimm->grain:

	/*
	 * The dram rank boundary (DRB) reg values are boundary addresses
	 * for each DRAM rank with a granularity of 64MB.  DRB regs are
	 * cumulative; the last one will contain the total memory
	 * contained in all ranks.
	 */
	for (i = 0; i < mci->nr_csrows; i++) {
		unsigned long nr_pages;
		struct csrow_info *csrow = &mci->csrows[i];

		nr_pages = drb_to_nr_pages(drbs, stacked,
			i / I3200_RANKS_PER_CHANNEL,
			i % I3200_RANKS_PER_CHANNEL);

		if (nr_pages == 0)
			continue;

		for (j = 0; j < nr_channels; j++) {
			struct dimm_info *dimm = csrow->channels[j].dimm;

			dimm->nr_pages = nr_pages / nr_channels;
			dimm->grain = nr_pages << PAGE_SHIFT;
	...


Assuming that errors are given by a Gausian distribution, the PDF parameters (mean, standard
derivation) when grain is equal to 1 is completely different than when grain is 64 MB.

That means that any correlation function used by an stochastic process analysis
will need to take the grain into account, in order to detect if a series of errors
are due to a random noise, or if they're due to a physical problem at the device.

> Oh, and by the way, this define is unused and can be removed.

Feel free to submit a patch for it.

Regards,
Mauro
