Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758066Ab0LBTy7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 14:54:59 -0500
Received: from ist.d-labs.de ([213.239.218.44]:43527 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757845Ab0LBTy5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 14:54:57 -0500
Date: Thu, 2 Dec 2010 20:54:05 +0100
From: Florian Mickler <florian@mickler.org>
To: Borislav Petkov <bp@amd64.org>
Cc: Tobias Karnat <tobias.karnat@googlemail.com>,
        Borislav Petkov <bp@alien8.de>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: edac_core: crashes on shutdown
Message-ID: <20101202205405.7ff38b7f@schatten.dmk.lab>
In-Reply-To: <20101202185123.GI27263@aftab>
References: <20101201123921.GA15530@a1.tnic>
	<1291209888.12511.11.camel@Tobias-Karnat>
	<20101201143329.GB18074@a1.tnic>
	<1291225614.8646.4.camel@Tobias-Karnat>
	<20101201193508.GA4916@liondog.tnic>
	<1291280613.10626.22.camel@Tobias-Karnat>
	<20101202152106.GA29301@a1.tnic>
	<1291306872.3898.7.camel@Tobias-Karnat>
	<20101202170610.GE27263@aftab>
	<20101202191412.288b82f8@schatten.dmk.lab>
	<20101202185123.GI27263@aftab>
X-Mailer: Claws Mail 3.7.6cvs31 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Dec 2010 19:51:23 +0100
Borislav Petkov <bp@amd64.org> wrote:

> On Thu, Dec 02, 2010 at 01:14:12PM -0500, Florian Mickler wrote:
> > Yes. That should work. Once we stopped the workqueue and removed it
> > from the global list, do we actually need to set it to OP_OFFLINE?
> 
> I think yes, because we seem to protect ourselves in the actual
> edac_mc_workq_function() on exit, if we overlap the work items
> cancellation with the execution of the delayed work at the same time on
> a different cpu. Besides, it is a single assignment and it does cost us
> almost nothing.

true. I wonder if the flush workqueue waits for the work-function
to finish? 

> 
> > Also 00740c585 did fix a hang in edac_mc.c... could this also happen
> > in the edac_device_del_device/edac_pci_del_device functions?
> 
> Nope, because there we don't check ->op_state when we cancel the work
> items in the respective _teardown() functions - we simply cancel them
> unconditionally.
> 

But shouldn't we check ->op_state for those as well? Why don't we hang
for those functions in similar cases as your original patch fixed?

