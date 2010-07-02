Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756304Ab0GBGUM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 02:20:12 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:35279 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754852Ab0GBGUI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 02:20:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=w825/Dscch2qeilzKqB2AtMqfkT+D6EnXyNI69MnBtJIQfq2T1dX/sX/hLZudNK5yc
         Jb13R43NZwGxOfSNSAp/TNwF3qnh8lRi+kSMzlhaDx0Nm5LabABaMz4aMFpc08mE6X1L
         b+N63Ivye5vSeMnva5tKGxC+MlPlX1wyHRpLg=
Date: Thu, 1 Jul 2010 23:20:00 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Jonathan Woithe <jwoithe@physics.adelaide.edu.au>,
       Matthew Garrett <mjg@redhat.com>, Len Brown <len.brown@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stefani Seibold <stefani@seibold.net>, Andi Kleen <ak@linux.intel.com>,
       platform-driver-x86@vger.kernel.org
Subject: Re: [PATCH] fujitsu-laptop: remove unnecessary input_free_device
 calls
Message-ID: <20100702061958.GA3691@core.coreip.homeip.net>
References: <1278034977.24246.6.camel@mola>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1278034977.24246.6.camel@mola>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Axel,

On Fri, Jul 02, 2010 at 09:42:57AM +0800, Axel Lin wrote:
> input_free_device should only be used if input_register_device()
> was not called yet or if it failed.
> This patch removes unnecessary input_free_device calls.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  drivers/platform/x86/fujitsu-laptop.c |   21 ++++++++-------------
>  1 files changed, 8 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/platform/x86/fujitsu-laptop.c b/drivers/platform/x86/fujitsu-laptop.c
> index e325aeb..dab1a0e 100644
> --- a/drivers/platform/x86/fujitsu-laptop.c
> +++ b/drivers/platform/x86/fujitsu-laptop.c
> @@ -686,8 +686,10 @@ static int acpi_fujitsu_add(struct acpi_device *device)
>  	set_bit(KEY_UNKNOWN, input->keybit);
>  
>  	error = input_register_device(input);
> -	if (error)
> -		goto err_free_input_dev;
> +	if (error) {
> +		input_free_device(input);
> +		goto err_stop;
> +	}

Instead of using mixed in-line and goto style cleanup I prefer doig the
following:

 err_unregister_input_dev:
	input_unregister_device(input);
	input = NULL; <-- !!!
 err_free_input_dev:
	input_free_device(input);

input_free_device() happily accepts NULL pointers.

Otherwise the patch looks good.

Thanks.

-- 
Dmitry
