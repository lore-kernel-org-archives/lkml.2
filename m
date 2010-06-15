Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753947Ab0FOH6q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 03:58:46 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:47850 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964Ab0FOH6p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 03:58:45 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4C173216.3040007@s5r6.in-berlin.de>
Date: Tue, 15 Jun 2010 09:56:06 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20100415 SeaMonkey/1.1.18
MIME-Version: 1.0
To: "Justin P. Mattock" <justinmattock@gmail.com>
CC: Valdis.Kletnieks@vt.edu, linux-kernel@vger.kernel.org,
       Peter Stuge <peter@stuge.se>, tpmdd-devel@lists.sourceforge.net,
       Debora Velarde <debora@linux.vnet.ibm.com>,
       Rajiv Andrade <srajiv@linux.vnet.ibm.com>,
       Marcel Selhorst <m.selhorst@sirrix.com>
Subject: Re: [PATCH 4/8]drivers:tmp.c Fix warning: variable 'rc' set but	not
 used
References: <1276547208-26569-1-git-send-email-justinmattock@gmail.com> <1276547208-26569-5-git-send-email-justinmattock@gmail.com> <21331.1276560832@localhost> <4C16E18F.9050901@gmail.com> <9275.1276573789@localhost> <4C16F9FC.2080905@gmail.com> <20100615052944.7746.qmail@stuge.se> <4C17169F.4060205@gmail.com> <4C17244D.7010806@s5r6.in-berlin.de> <4C172B73.6090609@gmail.com>
In-Reply-To: <4C172B73.6090609@gmail.com>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(adding Cc: tpm maintainers, after I had cut the Cc list earlier...)

Justin P. Mattock wrote:
> On 06/14/2010 11:57 PM, Stefan Richter wrote:
>> Justin P. Mattock wrote:
>>> On 06/14/2010 10:29 PM, Peter Stuge wrote:
>>>> Justin P. Mattock wrote:
>>>>> I have no manual in front of me. Did a quick google, but came up with
>>>>> (no hits) info on what that function does. grep showed too many
>>>>> entries
>>>>> to really see why/what this is.
>>>>
>>>> Check out the tool cscope. (Or kscope, if you prefer a GUI.)
>>>
>>> thanks for this tool.. I think this is what I need.. running around not
>>> knowing what/where the manual is for a call is a bit daunting.
>>
>> Similar to cscope/kscope but online:
>> http://lxr.free-electrons.com/
>> http://lxr.linux.no/linux
>>
>> E.g. http://lxr.free-electrons.com/ident?i=transmit_cmd
> 
> hmm.. yeah I use those guys a lot.. with grep also.. I think what might
> throw me off is things like def.orig = def.new then def.orig gets lost
> in the mix(or it's there, but the grep becomes gigantic in code
> results.) main thing I look for is googling "somedefinition linux man"
> for some idea of what that function does.
> 
> Justin P. Mattock

I'm afraid that even if there was inline documentation of the function,
it would still be near impossible to guess what to do with unused return
codes if one is not familiar with the hardware and with the driver.

To quote your original patch again:

> Im getting this warning when compiling:
>  CC      drivers/char/tpm/tpm.o
> drivers/char/tpm/tpm.c: In function 'tpm_gen_interrupt':
> drivers/char/tpm/tpm.c:508:10: warning: variable 'rc' set but not used
> 
> The below patch gets rid of the warning,
> but I'm not sure if it's the best solution.
> 
>  Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
> 
> ---
>  drivers/char/tpm/tpm.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/char/tpm/tpm.c b/drivers/char/tpm/tpm.c
> index 05ad4a1..3d685dc 100644
> --- a/drivers/char/tpm/tpm.c
> +++ b/drivers/char/tpm/tpm.c
> @@ -514,6 +514,8 @@ void tpm_gen_interrupt(struct tpm_chip *chip)
>  
>  	rc = transmit_cmd(chip, &tpm_cmd, TPM_INTERNAL_RESULT_SIZE,
>  			"attempting to determine the timeouts");
> +	if (!rc)
> +		rc = 0;
>  }
>  EXPORT_SYMBOL_GPL(tpm_gen_interrupt);

So, void tpm_gen_interrupt() itself clearly is not prepared to do
anything about an error return from transmit_cmd.  The question is, is
this OK and can the "rc = " simply be removed, or should
tpm_gen_interrupt gain some error handling, or should tpm_gen_interrupt
be changed to a non-void function and its callers check for errors in
tpm_gen_interrupt?

It could very well be that there is really no need or no possibility for
error handling.  But until somebody familiar with the matter has figured
this out, it is in fact better to leave the compiler warning in place.

Just silencing the compiler if the possibility exists that there is an
actual flaw here is not the way to go.  Still, good that you reported it
even with an RFC patch, since the authors were obviously unaware of such
a warning until now.
-- 
Stefan Richter
-=====-==-=- -==- -====
http://arcgraph.de/sr/
