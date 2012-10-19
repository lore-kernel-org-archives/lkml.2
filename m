Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945910Ab2JSPUq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 11:20:46 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:21556 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751321Ab2JSPUo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 11:20:44 -0400
Message-ID: <50816FC9.5080108@hp.com>
Date: Fri, 19 Oct 2012 09:20:41 -0600
From: Randy Wright <rwright@hp.com>
Organization: Hewlett-Packard Company
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:10.0.9) Gecko/20121011 Thunderbird/10.0.9
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: rwright@hp.com, Thavatchai Makphaibulchoke <tmac@hp.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH RFC] function probe_roms accessing improper addresses
References: <jQZho-4fF-13@gated-at.bofh.it> <jSWfn-7B6-3@gated-at.bofh.it>
In-Reply-To: <jSWfn-7B6-3@gated-at.bofh.it>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I would like to summarize progress I have made on this issue in the past
few days, and then appeal for help in evaluating the options.  Matthew
and H. Peter Anvin, I would appreciate your additional input especially.

The general idea under consideration here is to avoid access to the
legacy adapter space.  My original rfc patch applied this restriction to
all efi_enabled systems.  I am modifying this to implement this
as a quirk, and the question is how best to activate such a quirk.

Option 1: Activating via Machine Check

I investigated the idea of activating based on encountering a
machine check.  As an experiment, to avoid boot-time code sequencing
issues, I moved the probe_roms call to after the MC handler
initialization. However, I ran into prototype firmware issues.  As I had
suspected  might be the case, the  access was still treated as fatal by
platform firmware and the kernel machine check handler does not get a
chance to run.  Since I could not resolve this with resources available
to me, I had to set this approach aside.

Option 2: Activating via DMI properties

I have written and tested code implementing the following approach. With
just a bit of clean-up I could send this as a new patch RFC if it sounds
workable.

First, I added a new member to the x86_platform_ops structure:
    int (*legacy_range_accessible)(phys_addr_t);
The default function provided for this operation always returns an
indication that access is permitted.  If appropriate to the  platform,
the default function pointer can be replaced at runtime with a function
that disallows access. This provides a test by which post-boot code -
such  as devmem_is_allowed - can query whether access to a particular
address should be permitted.

Because this check must occur in a relatively small window between dmi
initialization and the call to probe_roms, I added what I think could be
a generally useful early quirk check at the end of dmi_scan_machine:

   if (dmi_available)
       dmi_check_system(dmi_early_quirks);

Here, dmi_early_quirks is a typical dmi_system_id array, initially
containing an entry for my prototype system.   When matched for the
properties of interest, it calls out via the .callback entry to a new
function I named x86_mark_legacy_adapter_range_inaccessible. This
function does the following:

a. it replaces the x86_init_resources.probe_roms function pointer with
x86_init_noop; and

b. it replaces the above-mentioned legacy_range_accessible callout in
the x86_platform_ops structure with a function that disapproves of
access to the legacy adapter region.

So in this approach, I don't patch the function probe_roms itself;
rather, I entirely avoid calling it.

A specific point on which I'd like to get advice is regarding the policy
for accepting a submission based on DMI properties of an unreleased
prototype platform.  This focuses on the weak point of any "opt-in" type
of quirk: if the DMI properties of the product change over the product
lifecyle (there's always a version n+1!) then the patch must be amended.
But at that point, the modification required is simply altering text
string content in a dmi_system_id array.


Option 3: Boot command line activation

| 3. Can it be activated on demand for testing on other platforms? A
| kernel boot command line parameter could be added, for example. How does
| the community feel about adding more of those?

I am considering this option in addition to - not instead of - the
automatic activation by the dmi properties, but it remains an area on
which I want to get further input before posting a new patch rfc: is it
appropriate to include a boot command interface to activate this feature
on demand for platforms that don't match via the DMI_MATCH criteria?  If
new boot command parameters are discouraged, is there a better paradigm
for forced activation that I should investigate?

Any other feedback?

--
Randy Wright            Hewlett-Packard Company
Phone: (970) 898-0998   Mail: rwright@hp.com
