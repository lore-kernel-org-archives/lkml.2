Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752083Ab1KEIOJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Nov 2011 04:14:09 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:32495 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862Ab1KEIOH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Nov 2011 04:14:07 -0400
Date: Sat, 5 Nov 2011 09:13:51 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: Alexander Beregalov <a.beregalov@gmail.com>, linux-kernel@vger.kernel.org,
        stable@kernel.org
Subject: Re: [PATCH] hwmon: (w83627ehf): fix broken driver init
Message-ID: <20111105091351.0d436eb5@endymion.delvare>
In-Reply-To: <20111105045156.GA10668@ericsson.com>
References: <1320454450-738-1-git-send-email-a.beregalov@gmail.com>
	<20111105045156.GA10668@ericsson.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alexander, Guenter,

On Fri, 4 Nov 2011 21:51:56 -0700, Guenter Roeck wrote:
> On Fri, Nov 04, 2011 at 08:54:10PM -0400, Alexander Beregalov wrote:
> > Commit 2265cef2 (hwmon: (w83627ehf) Properly report PECI and AMD-SI
> > sensor types) results in kernel panic if data->temp_label was not
> > initialized.
> > The problem was found with chip W83627DHG-P.
> > 
> > backtrace:
> > page_fault()
> > w83627ehf_probe() 0x8e2
> > 
> > w83627ehf_init_device:
> > 1837:	for (i = 0; i < 3; i++) {
> > 		const char *label = data->temp_label[data->temp_src[i]];
> > 
> > 		/* Digital source overrides analog type */
> > 		if (strncmp(label, "PECI", 4) == 0)
> > 			data->temp_type[i] = 6;
> > 
> > 	movzbl	128(%r14), %edx	# data->temp_src, tmp737
> > 	movq	144(%r13), %rax	# data_32->temp_label, data_32->temp_label
> > 	movq	$.LC18, %rsi	#,
> > 	movl	%r14d, %r15d	#, i
> > 	subl	%r13d, %r15d	# D.29277, i
> > 0x928	movq	(%rax,%rdx,8), %rcx	#* data_32->temp_label, label
> > 	movl	$4, %edx	#,
> > 	movq	%rcx, %rdi	# label,
> > 	movq	%rcx, -96(%rbp)	#,
> > 	call	strncmp	#
> > 
> > page_fault() is called at 0x928 (0x8e2+0x46).

Oops, my bad. I forgot that not all chips have temperature labels,
sorry :( Thanks for reporting so quickly!

> > 
> > Add check if data->temp->label was set before use.
> > 
> > Cc: Jean Delvare <khali@linux-fr.org>
> > Cc: Guenter Roeck <guenter.roeck@ericsson.com>
> > Cc: stable@kernel.org
> > Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
> > ---
> >  drivers/hwmon/w83627ehf.c |   17 +++++++++--------
> >  1 files changed, 9 insertions(+), 8 deletions(-)
> > 
> > diff --git a/drivers/hwmon/w83627ehf.c b/drivers/hwmon/w83627ehf.c
> > index 483cb26..70f1c73 100644
> > --- a/drivers/hwmon/w83627ehf.c
> > +++ b/drivers/hwmon/w83627ehf.c
> > @@ -1835,14 +1835,15 @@ static inline void __devinit w83627ehf_init_device(struct w83627ehf_data *data,
> >  		diode = 0x70;
> >  	}
> >  	for (i = 0; i < 3; i++) {
> > -		const char *label = data->temp_label[data->temp_src[i]];
> > -
> > -		/* Digital source overrides analog type */
> > -		if (strncmp(label, "PECI", 4) == 0)
> > -			data->temp_type[i] = 6;
> > -		else if (strncmp(label, "AMD", 3) == 0)
> > -			data->temp_type[i] = 5;
> > -		else if ((tmp & (0x02 << i)))
> > +		if (data->temp_label) {
> > +			const char *label = data->temp_label[data->temp_src[i]];
> > +
> > +			/* Digital source overrides analog type */
> > +			if (strncmp(label, "PECI", 4) == 0)
> > +				data->temp_type[i] = 6;
> > +			else if (strncmp(label, "AMD", 3) == 0)
> > +				data->temp_type[i] = 5;
> > +		} else if ((tmp & (0x02 << i)))
> 
> Followup - something like
> 		const char *label = NULL;
> 
> 		if (data->temp_label)
> 			label = data->temp_label[data->temp_src[i]];
> 
> 		/* Digital source overrides analog type */
> 		if (label && strncmp(label, "PECI", 4) == 0)
> 			data->temp_type[i] = 6;
> 		else if (label && strncmp(label, "AMD", 3) == 0)
> 			data->temp_type[i] = 5;
> 		else if ((tmp & (0x02 << i)))
> 
> should do it. I am open to better ideas...

Looks good enough to me, this is one-time initialization code, it
doesn't need to be lightning fast. Will you send a formal patch, or do
you want me to do it?

-- 
Jean Delvare
