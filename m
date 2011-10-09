Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751600Ab1JIGsg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Oct 2011 02:48:36 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:37657 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750817Ab1JIGsf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Oct 2011 02:48:35 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.15 with qID p996mHka001733, This message is released by code: ctaloc0852
X-BOX-Message-Id: p996mHka001733
Message-ID: <4E9143B1.3040300@realsil.com.cn>
Date: Sun, 9 Oct 2011 14:48:17 +0800
From: wwang <wei_wang@realsil.com.cn>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0.1) Gecko/20111001 Thunderbird/7.0.1
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: "gregkh@suse.de" <gregkh@suse.de>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] staging:rts_pstor:Fix SDIO issue
References: <1318125810-30505-1-git-send-email-wei_wang@realsil.com.cn> <20111009060644.GN18470@longonot.mountain>
In-Reply-To: <20111009060644.GN18470@longonot.mountain>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Carpenter:

Yes, the new code is exactly what I intended.
As to the following code, the old system responded fully wrong. It
should return STATUS_FAIL here instead.

3144 if (CHECK_PID(chip, 0x5209)) {
3145 retval = sd_change_bank_voltage(chip, SD_IO_3V3);
3146 if (retval != STATUS_SUCCESS) {
3147 TRACE_RET(chip, STATUS_FAIL);
3148 }
3149 }


Indeed, returning STATUS_FAIL directly would look like more consice and
neat. But in the following code (line 3164) it would not work because we
may need to call reset_mmc function. In order to keep the code
consistent, I introduce the "reset_pass" variable.
Another method to fix this bug is to add "retval = STATUS_FAIL" after
line 3167. But I don't think this style is clear enough, comparing with
adding a new variable.

3157 retval = reset_sd(chip);
3158 if (retval != STATUS_SUCCESS) {
3159 if (sd_check_err_code(chip, SD_NO_CARD)) {
3160 TRACE_RET(chip, STATUS_FAIL);
3161 }
3162
3163 if (CHECK_PID(chip, 0x5209)) {
3164 retval = sd_change_bank_voltage(chip, SD_IO_3V3);
3165 if (retval != STATUS_SUCCESS) {
3166 TRACE_RET(chip, STATUS_FAIL);
3167 }
3168 }
3169
3170 if (!chip->sd_io) {
3171 retval = reset_mmc(chip);
3172 if (retval == STATUS_SUCCESS)
3173 reset_pass = 1;
3174 }
3175 } else {
3176 reset_pass = 1;
3177 }


Best regards,
wwang

