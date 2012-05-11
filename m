Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932168Ab2EKGPn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 02:15:43 -0400
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:55144 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753922Ab2EKGPe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 02:15:34 -0400
Message-ID: <4FACAE84.6080501@hrz.tu-chemnitz.de>
Date: Fri, 11 May 2012 08:15:32 +0200
From: Markus Franke <markus.franke@s2002.tu-chemnitz.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Markus Franke <markus.franke@s2002.tu-chemnitz.de>,
        Greg KH <greg@kroah.com>, Evgeniy Polyakov <zbr@ioremap.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] w1: Add 1-wire slave device driver for DS28E04-100
References: <20120503180056.GB13988@ioremap.net> <4FAAD584.70102@hrz.tu-chemnitz.de> <20120509220636.GA27659@kroah.com> <4FAAECB7.8070904@hrz.tu-chemnitz.de> <20120509222411.GA24302@kroah.com> <4FAAF1C4.2050500@hrz.tu-chemnitz.de> <20120509235723.GA7404@ioremap.net> <20120510000126.GA2357@kroah.com> <20120510004350.GA8362@ioremap.net> <4FAB4A4D.8080901@hrz.tu-chemnitz.de> <20120510151639.GE17472@kroah.com> <4FAC47F6.6080903@hrz.tu-chemnitz.de> <20120510162227.5cf2294b.akpm@linux-foundation.org>
In-Reply-To: <20120510162227.5cf2294b.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Scan-AV: cora.hrz.tu-chemnitz.de;2012-05-11 08:15:33;c440a542d0347d03eee0588e41783d1a
X-Scan-SA: cora.hrz.tu-chemnitz.de;2012-05-11 08:15:33;e23f5e0c72da29ea8ecaa7dea4e5cfba
X-Spam-Score: -1.0 (-)
X-Spam-Report: --- Textanalyse SpamAssassin 3.3.1 (-1.0 Punkte)
 Fragen an/questions to:  Postmaster TU Chemnitz <postmaster@tu-chemnitz.de>
 * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
 --- Ende Textanalyse
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Andrew,

thanks for the feedback.

Am 11.05.2012 01:22, schrieb Andrew Morton:

> On Fri, 11 May 2012 00:57:58 +0200
> Markus Franke <markus.franke@s2002.tu-chemnitz.de> wrote:
> 
>> +static int w1_f1C_add_slave(struct w1_slave *sl)
>> +{
>> +	int err = 0;
>> +	int i;
>> +	struct w1_f1C_data *data = NULL;
>> +
>> +	if (w1_enable_crccheck) {
>> +		data = kzalloc(sizeof(struct w1_f1C_data), GFP_KERNEL);
>> +		if (!data)
>> +			return -ENOMEM;
>> +		sl->family_data = data;
>> +	}
>> +
>> +	/* create binary sysfs attributes */
>> +	for (i = 0; i < NB_SYSFS_BIN_FILES && !err; ++i)
>> +		err = sysfs_create_bin_file(
>> +			&sl->dev.kobj, &(w1_f1C_bin_attr[i]));
>> +
>> +	if (err)
>> +		goto out;
> 
> If this goto is taken, we will leak 0..i sysfs files.


That's indeed the case. :-(

>> +	/* create device attributes */
>> +	err = device_create_file(&sl->dev, &dev_attr_crccheck);
>> +
>> +	if (err) {
>> +		/* remove binary sysfs attributes */
>> +		for (i = 0; i < NB_SYSFS_BIN_FILES; ++i)
>> +			sysfs_remove_bin_file(
>> +				&sl->dev.kobj, &(w1_f1C_bin_attr[i]));
>> +	}
>> +
>> +out:
>> +	if (err) {
>> +		if (w1_enable_crccheck)
>> +			kfree(data);
> 
> kfree(NULL) is legal - the w1_enable_crccheck test can be removed.


Ok, I'll fix this for the next (hopefully final) version of the patch.

Best regards,
Markus Franke
