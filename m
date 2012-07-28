Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752603Ab2G1Apr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 20:45:47 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:61430 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236Ab2G1Apq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 20:45:46 -0400
MIME-Version: 1.0
In-Reply-To: <5013118D.2030601@zytor.com>
References: <20120727181436.GA6271@linux.vnet.ibm.com>
	<5012DCF9.7010408@zytor.com>
	<20120727203000.GA22684@linux.vnet.ibm.com>
	<5013118D.2030601@zytor.com>
Date: Fri, 27 Jul 2012 19:45:45 -0500
Message-ID: <CAM0nabH2629Qx_inhzDuAGggy6rwZJ=rO68yrXie9TtEP6qKuQ@mail.gmail.com>
Subject: Re: [GIT PULL] New TPM driver, hwrng driver and fixes
From: Kent Yoder <shpedoikal@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Kent Yoder <key@linux.vnet.ibm.com>, James Morris <jmorris@namei.org>,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        tpmdd-devel@lists.sourceforge.net,
        Peter Huewe <peter.huewe@infineon.com>,
        Bryan Freed <bfreed@chromium.org>,
        David Safford <safford@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> +                     /* err can be positive if it came from the TPM itself,
>> +                      * so return a negative value here instead. */
>> +                     err = -EFAULT;
>
> -EFAULT is definitely wrong (that means a bad pointer was passed), you
> can use -EIO instead.
>
> However, I would suggest:
>
>         err = total ? total : -EIO;

 This is fine w/ me...

> ... so you report the number of bytes successfully received if we got
> any.  However, since you *also* do that on the retry line,
>
>> +                     goto out_err;
>> +             }
>> +
>> +             recd = be32_to_cpu(tpm_cmd.params.getrandom_out.rng_data_len);
>> +             memcpy(dest, tpm_cmd.params.getrandom_out.rng_data, recd);
>> +
>> +             dest += recd;
>> +             total += recd;
>> +             num_bytes -= recd;
>> +     } while (retries-- && total < max);
>> +
>> +     err = total;
>
> Should we return something other than 0 if we run out of retries here, too?

  Ugh, I was hoping to avoid this kind of complexity.

> Perhaps we should just do the same "err = total ? total : -EIO;" here
> and the above statement can just turn into a break;.

  Yeah, this seems like the right thing to do.

>> -     ret = my_get_random(hash, SHA1_DIGEST_SIZE);
>> +     ret = tpm_get_random(TPM_ANY_NUM, hash, SHA1_DIGEST_SIZE);
>>       if (ret < 0)
>>               return ret;
>
> You are still not checking the return values correctly!

  Dave, can you weigh in on these individual cases?  In some cases
like capping a pcr I think using uninitialized stack data could be
better than failing...

Kent

> This needs to be something like:
>
>         ret = tpm_get_random(TPM_ANY_NUM, hash, SHA1_DIGEST_SIZE);
>         if (ret != SHA1_DIGEST_SIZE)
>                 return -EIO;    /* Or whatever is appropriate here */
>
>
>         -hpa
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



-- 
IBM LTC Security
