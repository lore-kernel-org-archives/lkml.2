Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755386Ab1BUPau (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 10:30:50 -0500
Received: from e24smtp04.br.ibm.com ([32.104.18.25]:41865 "EHLO
	e24smtp04.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754270Ab1BUPat (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 10:30:49 -0500
Message-ID: <4D628521.8000205@linux.vnet.ibm.com>
Date: Mon, 21 Feb 2011 12:30:41 -0300
From: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Jiri Slaby <jirislaby@gmail.com>, stefanb@linux.vnet.ibm.com,
        linux-pm <linux-pm@lists.linux-foundation.org>, stable@kernel.org,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        debora@linux.vnet.ibm.com,
        Linus Torvalds <torvalds@linux-foundation.org>, preining@logic.at
Subject: Re: 2.6.37.1 s2disk regression (TPM)
References: <4D60E93D.1050205@gmail.com> <4D60F108.9000106@gmail.com> <201102201151.11635.rjw@sisk.pl> <201102201248.10779.rjw@sisk.pl>
In-Reply-To: <201102201248.10779.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 11022115-8936-0000-0000-000000B0F567
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/20/2011 08:48 AM, Rafael J. Wysocki wrote:

> On Sunday, February 20, 2011, Rafael J. Wysocki wrote:
>> No, and the author and maintainer have not been responding.  If that contiunes,I'll simply ask Linus to revert it.
Sorry, but you sent the email this Friday, I didn't catch it in time and I wasn't working during the weekend.

> BTW, the first hunk from that commit in drivers/char/tpm/tpm.c seems to be
> completely broken:
>
> @@ -577,9 +577,11 @@ duration:
>          if (rc)
>                  return;
>
> -       if (be32_to_cpu(tpm_cmd.header.out.return_code)
> -           != 3 * sizeof(u32))
> +       if (be32_to_cpu(tpm_cmd.header.out.return_code) != 0 ||
> +           be32_to_cpu(tpm_cmd.header.out.length)
> +           != sizeof(tpm_cmd.header.out) + sizeof(u32) + 3 * sizeof(u32))
>                  return;
> +
>          duration_cap =&tpm_cmd.params.getcap_out.cap.duration;
>          chip->vendor.duration[TPM_SHORT] =
>              usecs_to_jiffies(be32_to_cpu(duration_cap->tpm_short));
>
> Namely, either the old code always returned as a result of the conditional
> being removed, or the new code will always return as a result of
> the (... != 0) check.  I wonder if there's supposed to be (... == 0) instead?
The previous code was checking the wrong field of the TPM returned buffer, probably
due an old commit that incorporated the tpm_cmd strucuture, it should check if the return code
is != 0, which if true, means that the command didn't succeed. The output length check should be
just a sanity check, so indeed the logical operator should be&&  instead. Although it should also be
fixed, I don't think this is the cause, since in case the timeout retrieval from the TPM fail,
the device driver falls back to default values, which has been working before this commit.

> [And why not to simply use 4*sizeof(u32) FWIW?]
I can't see why, I'll update it.

The failure for this specific board then sounds to be due the TPM returning inconsistent timeout values.
Norbert, can 'cat /sys/devices/pnp0/00\:0*/timeouts' and send the output?

Rajiv


