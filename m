Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755393Ab0FXMtj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 08:49:39 -0400
Received: from ppsw-31.csi.cam.ac.uk ([131.111.8.131]:45960 "EHLO
	ppsw-31.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755026Ab0FXMti (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 08:49:38 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4C235523.6000204@jic23.retrosnub.co.uk>
Date: Thu, 24 Jun 2010 13:52:51 +0100
From: Jonathan Cameron <kernel@jic23.retrosnub.co.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100426 Thunderbird/3.0.4
MIME-Version: 1.0
To: "Datta, Shubhrajyoti" <shubhrajyoti@ti.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Christoph Mair <christoph.mair@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] BMP085  : Change the macro to swap
References: <0680EC522D0CC943BC586913CF3768C003B3553D0C@dbde02.ent.ti.com>
In-Reply-To: <0680EC522D0CC943BC586913CF3768C003B3553D0C@dbde02.ent.ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/24/10 13:41, Datta, Shubhrajyoti wrote:
> 
> Changing the macro to swap the bytes as the reason that the first byte is the MSB and the next is LSB.
Are you sure on this one?

The swap would be right if you were using an i2c function that is aware that it is
reading word data (16bit).

Here it just thinks it is reading a string of bytes.  Hence the bytes will indeed
come out big endian.  So if you have a big endian machine this patch will swap the
bytes round incorrectly.

Of course I might just be half asleep today ;)
> 
> Signed-off-by: Shubhrajyoti D <shubhrajyoti@ti.com>
> ---
>  drivers/misc/bmp085.c |   41 +++++++++++++++++++++++++++++------------
>  1 files changed, 29 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/misc/bmp085.c b/drivers/misc/bmp085.c
> index 8af6f1b..74c5b12 100644
> --- a/drivers/misc/bmp085.c
> +++ b/drivers/misc/bmp085.c
> @@ -79,18 +79,35 @@ static s32 bmp085_read_calibration_data(struct i2c_client *client)
>  
>  	if (status != BMP085_CALIBRATION_DATA_LENGTH*sizeof(u16))
>  		return -EIO;
> -
> -	cali->AC1 =  be16_to_cpu(tmp[0]);
> -	cali->AC2 =  be16_to_cpu(tmp[1]);
> -	cali->AC3 =  be16_to_cpu(tmp[2]);
> -	cali->AC4 =  be16_to_cpu(tmp[3]);
> -	cali->AC5 =  be16_to_cpu(tmp[4]);
> -	cali->AC6 = be16_to_cpu(tmp[5]);
> -	cali->B1 = be16_to_cpu(tmp[6]);
> -	cali->B2 = be16_to_cpu(tmp[7]);
> -	cali->MB = be16_to_cpu(tmp[8]);
> -	cali->MC = be16_to_cpu(tmp[9]);
> -	cali->MD = be16_to_cpu(tmp[10]);
> +/*
> + * From the datasheet
> + *
> + * BMP085 Reg Addr
> + * parameter	|	MSB	|	LSB
> + * AC1		|	0xAA	|	0xAB
> + * AC2		|	0xAC	|	0xAD
> + * AC3		|	0xAE	|	0xAF
> + * AC4		|	0xB0	|	0xB1
> + * AC5		|	0xB2	|	0xB3
> + * AC6		|	0xB4	|	0xB5
> + * B1		|	0xB6	|	0xB7
> + * B2		|	0xB8	|	0xB9
> + * MB		|	0xBA	|	0xBB
> + * MC		|	0xBC	|	0xBD
> + * MC		|	0xBE	|	0xBF
> + *
> + */
> +	cali->AC1 =  swab16(tmp[0]);
> +	cali->AC2 =  swab16(tmp[1]);
> +	cali->AC3 =  swab16(tmp[2]);
> +	cali->AC4 =  swab16(tmp[3]);
> +	cali->AC5 =  swab16(tmp[4]);
> +	cali->AC6 = swab16(tmp[5]);
> +	cali->B1 = swab16(tmp[6]);
> +	cali->B2 = swab16(tmp[7]);
> +	cali->MB = swab16(tmp[8]);
> +	cali->MC = swab16(tmp[9]);
> +	cali->MD = swab16(tmp[10]);
>  	return 0;
>  }
>  

