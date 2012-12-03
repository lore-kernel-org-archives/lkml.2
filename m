Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752423Ab2LCU2D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 15:28:03 -0500
Received: from mail.skyhub.de ([78.46.96.112]:51111 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751511Ab2LCU2A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 15:28:00 -0500
Date: Mon, 3 Dec 2012 21:27:56 +0100
From: Borislav Petkov <bp@alien8.de>
To: "Ortiz, Lance E" <lance.oritz@hp.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "lance_ortiz@hotmail.com" <lance_ortiz@hotmail.com>,
        "jiang.liu@huawei.com" <jiang.liu@huawei.com>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Zhang Yanmin <yanmin.zhang@intel.com>
Subject: Re: [PATCH v3 1/3] aerdrv: Trace Event for AER
Message-ID: <20121203202756.GB14798@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	"Ortiz, Lance E" <lance.oritz@hp.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	"bhelgaas@google.com" <bhelgaas@google.com>,
	"lance_ortiz@hotmail.com" <lance_ortiz@hotmail.com>,
	"jiang.liu@huawei.com" <jiang.liu@huawei.com>,
	"tony.luck@intel.com" <tony.luck@intel.com>,
	"rostedt@goodmis.org" <rostedt@goodmis.org>,
	"linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
	"linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Zhang Yanmin <yanmin.zhang@intel.com>
References: <20121130213330.7649.51101.stgit@grignak.americas.hpqcorp.net>
 <20121201093614.720aa96a@redhat.com>
 <A961433CDFF2F640A2866803152E61F9516EE717@G4W3218.americas.hpqcorp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <A961433CDFF2F640A2866803152E61F9516EE717@G4W3218.americas.hpqcorp.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 03, 2012 at 08:01:46PM +0000, Ortiz, Lance E wrote:
> > > +#define correctable_error_string			\
> > > +	{BIT(0),	"Receiver Error"},		\
> > > +	{BIT(6),	"Bad TLP"},			\
> > > +	{BIT(7),	"Bad DLLP"},			\
> > > +	{BIT(8),	"RELAY_NUM Rollover"},		\
> > > +	{BIT(12),	"Replay Timer Timeout"},	\
> > > +	{BIT(13),	"Advisory Non-Fatal"}
> > 
> > Hmm... isn't something missing here? I'm seeing more bits defined at
> > the
> > PCIe V3.0 spec for Offset 10h:
> > 
> > bit 14 - Corrected Internal Error
> > bit 15 - Header Log Overflow
> > 
> > > +#define uncorrectable_error_string			\
> > > +	{BIT(4),	"Data Link Protocol"},		\
> > > +	{BIT(12),	"Poisoned TLP"},		\
> > > +	{BIT(13),	"Flow Control Protocol"},	\
> > > +	{BIT(14),	"Completion Timeout"},		\
> > > +	{BIT(15),	"Completer Abort"},		\
> > > +	{BIT(16),	"Unexpected Completion"},	\
> > > +	{BIT(17),	"Receiver Overflow"},		\
> > > +	{BIT(18),	"Malformed TLP"},		\
> > > +	{BIT(19),	"ECRC"},			\
> > > +	{BIT(20),	"Unsupported Request"}
> > 
> > Hmm... isn't something missing here? I'm seeing more bits defined at
> > the
> > PCIe V3.0 spec for Offset 04h:
> > 
> > bit 5 - Surprise Down Error
> > bit 21 - ACS Violation
> > bit 22 - Uncorrectable Internal Error
> > bit 23 - MC Blocked TLP
> > bit 24 - AtomicOp Egress Blocked
> > bit 25 - TLP Prefix Blocked Error
> > 
> I used the same errors defined in the string arrays at the top of
> aerdrv_errprint.c. I am not sure why they were left out in that file.
> I will investigate and probably add them as a later patch and then
> include them in aerdrv_errprint.c also.

Maybe we should ask Yanmin who added those strings in
6c2b374d74857e892080ee726184ec1d15e7d4e4; CCed.

Also, it would make a lot of sense to have those string definitions
at one place and then reuse them instead of define them again in the
tracepoint header and they get out of sync and have needless duplication
in the kernel, etc, etc.

So, instead, you could define some macros which can generate your
strings above like this:

#define aer_uncor_err_str(bitnum)	\
	{ BIT(bitnum), aer_uncorrectable_error_string(bitnum) }

and use that macro for the __print_flags flag_array argument.

Or something to that effect.

Even better would it be if the error strings in
<drivers/pci/pcie/aer/aerdrv_errprint.c> could be shared with the
tracepoint ones. That would require a bit more changes though but
something like using an array of trace_print_flags instead an array of
strings could be doable.

Then, when you need the string, you do uncor_err_array[i].name and so
on.

Thanks.

-- 
Regards/Gruss,
    Boris.
