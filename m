Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755402Ab1D3KGr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 06:06:47 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:50796 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755038Ab1D3KGo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 06:06:44 -0400
Date: Sat, 30 Apr 2011 11:07:05 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
Cc: linux-kernel@vger.kernel.org,
        Jonas Fonseca <jonas.fonseca@savoirfairelinux.com>,
        platform-driver-x86@vger.kernel.org, linux-serial@vger.kernel.org,
        lm-sensors@lm-sensors.org
Subject: Re: [RFC 1/5] platform-drivers-x86: add support for Technologic
 Systems TS-5xxx detection
Message-ID: <20110430110705.5ca3376b@lxorguk.ukuu.org.uk>
In-Reply-To: <1304115712-5299-2-git-send-email-vivien.didelot@savoirfairelinux.com>
References: <1304115712-5299-1-git-send-email-vivien.didelot@savoirfairelinux.com>
	<1304115712-5299-2-git-send-email-vivien.didelot@savoirfairelinux.com>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> + * ts5xxx_sbcinfo_set() - set the SBC info structure with the current SBC's info
> + * @sbcinfo:		structure containing SBC info to set.
> + */
> +void ts5xxx_sbcinfo_set(struct ts5xxx_sbcinfo *sbcinfo)
> +{
> +	memcpy(sbcinfo, &ts_sbcinfo, sizeof(*sbcinfo));
> +}
> +EXPORT_SYMBOL(ts5xxx_sbcinfo_set);

You export this but it's not clear who for or why - and there is also no
locking, so it seems to be an internal interface ?


> +/**
> + * ts_find_sbc_config() - find a SBC configuration from an id
> + * @id:			ID of the board to find.
> + */
> +static inline struct ts_sbc_config *ts_find_sbc_config(u8 id)
> +{
> +	int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(ts_sbcs_configs); i++)
> +		if (id == ts_sbcs_configs[i].id)
> +			return &ts_sbcs_configs[i];
> +
> +	return NULL;
> +}

gcc will figure out inlines for you in static stuff and normally very well

> +
> +/**
> + * ts_sbcinfo_detect() - detect the TS board
> + * @sbcinfo:		structure where to store the detected board's info.
> + */
> +static int ts_sbcinfo_detect(struct ts5xxx_sbcinfo *sbcinfo)
> +{
> +	u8 temp;
> +	struct ts_sbc_config *sbc;
> +	int ret = 0;
> +
> +	memset(sbcinfo, 0, sizeof(*sbcinfo));
> +
> +	if (!request_region(IOADDR_SBCID, 4, "TS-SBC"))
> +		return -EBUSY;
> +
> +	temp = inb(IOADDR_SBCID);
> +	/* If it is a 3x00 SBC only match against the first 3 bits */
> +	if (temp & 0x07)
> +		temp &= 0x07;

So if this is compiled into a kernel we blindly inb this address and some
platform just crashed on boot. Is this board like other embedded ones in
that there is some safe way to check if its such a board first ?

> +
> +	sbc = ts_find_sbc_config(temp);
> +	if (!sbc) {
> +		ret = -ENODEV;

Assuming you've indentified the board properly this case might be worth a
pr_err giving the fact it seemed to be a TS-5xxx, the config number and
that it is unknown - that will help anyone with future boards realise
their config isn't supported.


> +
> +/**
> + * ts_sbcinfo_proc_read() - function called when a read access is done on
> + *                          /proc/ts-sbcinfo
> + */
> +static int ts_sbcinfo_proc_read(char *page, char **start, off_t off,
> +				int count, int *eof, void *data)
> +{
> +	int to_copy = (procfs_buffer_size <= count) ?
> +		procfs_buffer_size - off : count;

> +
> +	if (off + to_copy >= procfs_buffer_size) {
> +		to_copy = procfs_buffer_size - off;
> +		*eof = 1;
> +	}

Suppose off is 0x7FFFFFFF and count = 100

	to_copy = 100
	off + to_copy >= procfs_buffer_size   [off_t may be 32bit]

	100 + 0x7FFFFFFF (wraps) < buffer size


> +static int __init ts5xxx_sbcinfo_init(void)
> +{
> +	int err;
> +
> +	err = ts_sbcinfo_detect(&ts_sbcinfo);
> +	if (err < 0) {
> +		printk(KERN_ERR KBUILD_MODNAME
> +		       ": Failed to get SBC information\n");
> +		return err;
> +	}

Well that will depend why and probably the caller can give the best
information including silence if the board is just not a ts-5xxx

> +	proc_entry = create_proc_read_entry(PROCFS_NAME, S_IRUGO, NULL,
> +					    ts_sbcinfo_proc_read, 0);
> +	if (proc_entry == NULL) {
> +		printk(KERN_ERR KBUILD_MODNAME
> +		       ": Failed to create proc entry\n");

pr_err

> +		return -ENOMEM;
> +	}
> +
> +	procfs_buffer_size = ts_sbcinfo_init_buffer(procfs_buffer, &ts_sbcinfo);
> +	printk(KBUILD_MODNAME ": TS SBC's info driver loaded.\n");

Printk not needed

Alan
