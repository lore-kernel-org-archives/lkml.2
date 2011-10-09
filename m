Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751533Ab1JIGJp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Oct 2011 02:09:45 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:52842 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750850Ab1JIGJo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Oct 2011 02:09:44 -0400
Date: Sun, 9 Oct 2011 09:06:44 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: wei_wang@realsil.com.cn
Cc: gregkh@suse.de, devel@linuxdriverproject.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging:rts_pstor:Fix SDIO issue
Message-ID: <20111009060644.GN18470@longonot.mountain>
References: <1318125810-30505-1-git-send-email-wei_wang@realsil.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1318125810-30505-1-git-send-email-wei_wang@realsil.com.cn>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4E913AA1.01AB:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding the check for if (sd_check_err_code(chip, SD_NO_CARD)) is
good, but introducing the new "reset_pass" variable is wrong.

I don't think you are updating the new variable consistently on
all paths.  For example, if it's a 0x5209 chip and the code is like
this:
                   retval = sd_change_bank_voltage(chip, SD_IO_3V3);
                   if (retval != STATUS_SUCCESS) {
                   	TRACE_RET(chip, STATUS_FAIL);
                   }

In the old system that was considered a successful reset, but under
your new system we don't update "reset_pass" here so we pass this
test and then we immediately return STATUS_FAIL because reset_pass
isn't set.  If that's what you intended then just write it like that.

		retval = sd_change_bank_voltage(chip, SD_IO_3V3);
		TRACE_RET(chip, STATUS_FAIL);

So could you write it again but just set retval = STATUS_FAIL; for
the new failure pathes.  Or better yet, just return STATUS_FAIL
directly.  So this code would be:

> +				if (retval == STATUS_SUCCESS)
> +					reset_pass = 1;

				if (retval != STATUS_SUCCESS)
					TRACE_RET(chip, retval);
regards,
dan carpenter


