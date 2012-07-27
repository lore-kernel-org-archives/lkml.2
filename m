Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752504Ab2G0WJk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 18:09:40 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52523 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752125Ab2G0WJj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 18:09:39 -0400
Message-ID: <5013118D.2030601@zytor.com>
Date: Fri, 27 Jul 2012 15:09:17 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Kent Yoder <key@linux.vnet.ibm.com>
CC: James Morris <jmorris@namei.org>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        tpmdd-devel@lists.sourceforge.net,
        Peter Huewe <peter.huewe@infineon.com>,
        Bryan Freed <bfreed@chromium.org>,
        David Safford <safford@linux.vnet.ibm.com>
Subject: Re: [GIT PULL] New TPM driver, hwrng driver and fixes
References: <20120727181436.GA6271@linux.vnet.ibm.com> <5012DCF9.7010408@zytor.com> <20120727203000.GA22684@linux.vnet.ibm.com>
In-Reply-To: <20120727203000.GA22684@linux.vnet.ibm.com>
X-Enigmail-Version: 1.4.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/27/2012 01:30 PM, Kent Yoder wrote:

> +
> +	do {
> +		tpm_cmd.header.in = tpm_getrandom_header;
> +		tpm_cmd.params.getrandom_in.num_bytes = cpu_to_be32(num_bytes);
> +
> +		err = transmit_cmd(chip, &tpm_cmd,
> +				   TPM_GETRANDOM_RESULT_SIZE + num_bytes,
> +				   "attempting get random");
> +		if (err) {
> +			/* err can be positive if it came from the TPM itself,
> +			 * so return a negative value here instead. */
> +			err = -EFAULT;

-EFAULT is definitely wrong (that means a bad pointer was passed), you
can use -EIO instead.

However, I would suggest:

	err = total ? total : -EIO;

... so you report the number of bytes successfully received if we got
any.  However, since you *also* do that on the retry line,

> +			goto out_err;
> +		}
> +
> +		recd = be32_to_cpu(tpm_cmd.params.getrandom_out.rng_data_len);
> +		memcpy(dest, tpm_cmd.params.getrandom_out.rng_data, recd);
> +
> +		dest += recd;
> +		total += recd;
> +		num_bytes -= recd;
> +	} while (retries-- && total < max);
> +
> +	err = total;

Should we return something other than 0 if we run out of retries here, too?

Perhaps we should just do the same "err = total ? total : -EIO;" here
and the above statement can just turn into a break;.

> -	ret = my_get_random(hash, SHA1_DIGEST_SIZE);
> +	ret = tpm_get_random(TPM_ANY_NUM, hash, SHA1_DIGEST_SIZE);
>  	if (ret < 0)
>  		return ret;

You are still not checking the return values correctly!

This needs to be something like:

	ret = tpm_get_random(TPM_ANY_NUM, hash, SHA1_DIGEST_SIZE);
	if (ret != SHA1_DIGEST_SIZE)
		return -EIO;	/* Or whatever is appropriate here */


	-hpa
