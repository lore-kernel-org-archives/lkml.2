Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753019Ab2AaKIi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 05:08:38 -0500
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:43066 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751932Ab2AaKIh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 05:08:37 -0500
Subject: Re: [PATCH v2 08/16] ivtv-driver: fix handling of 'radio' module
 parameter
From: Andy Walls <awalls@md.metrocast.net>
To: Danny Kukawka <danny.kukawka@bisect.de>, mchehab@redhat.com,
        Rusty Russell <rusty@rustcorp.com.au>
Cc: Andy Walls <awalls@md.metrocast.net>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        ivtv-devel@ivtvdriver.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Tue, 31 Jan 2012 05:07:53 -0500
In-Reply-To: <1327952458-7424-9-git-send-email-danny.kukawka@bisect.de>
References: <1327952458-7424-1-git-send-email-danny.kukawka@bisect.de>
	 <1327952458-7424-9-git-send-email-danny.kukawka@bisect.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 8bit
Message-ID: <1328004475.2821.12.camel@palomino.walls.org>
Mime-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.6.7361,1.0.211,0.0.0000
 definitions=2012-01-31_04:2012-01-31,2012-01-31,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 ipscore=0 suspectscore=0
 phishscore=0 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=6.0.2-1012030000 definitions=main-1201310023
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-01-30 at 20:40 +0100, Danny Kukawka wrote:
> Fixed handling of 'radio' module parameter from module_param_array
> to module_param_named to fix these compiler warnings in ivtv-driver.c:
> 
> In function ‘__check_radio’:
> 113:1: warning: return from incompatible pointer type [enabled by default]
> At top level:
> 113:1: warning: initialization from incompatible pointer type [enabled by default]
> 113:1: warning: (near initialization for ‘__param_arr_radio.num’) [enabled by default]
> 
> Set initial state of radio_c to true instead of 1.

NACK.

"radio" is an array of tristate values (-1, 0, 1) per installed card:

	static int radio[IVTV_MAX_CARDS] = { -1, -1,

and must remain an array or you will break the driver.

Calling "radio_c" a module parameter named "radio" is wrong.

The correct fix is to reverse Rusty Russel's patch to the driver in
commit  90ab5ee94171b3e28de6bb42ee30b527014e0be7
to change the "bool" to an "int" as it should be in
"module_param_array(radio, ...)"

Regards,
Andy


> Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>
> ---
>  drivers/media/video/ivtv/ivtv-driver.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/video/ivtv/ivtv-driver.c b/drivers/media/video/ivtv/ivtv-driver.c
> index 3949b7d..dbd78d5 100644
> --- a/drivers/media/video/ivtv/ivtv-driver.c
> +++ b/drivers/media/video/ivtv/ivtv-driver.c
> @@ -99,7 +99,7 @@ static int i2c_clock_period[IVTV_MAX_CARDS] = { -1, -1, -1, -1, -1, -1, -1, -1,
>  
>  static unsigned int cardtype_c = 1;
>  static unsigned int tuner_c = 1;
> -static bool radio_c = 1;
> +static bool radio_c = true;
>  static unsigned int i2c_clock_period_c = 1;
>  static char pal[] = "---";
>  static char secam[] = "--";
> @@ -139,7 +139,7 @@ static int tunertype = -1;
>  static int newi2c = -1;
>  
>  module_param_array(tuner, int, &tuner_c, 0644);
> -module_param_array(radio, bool, &radio_c, 0644);
> +module_param_named(radio, radio_c, bool, 0644);
>  module_param_array(cardtype, int, &cardtype_c, 0644);
>  module_param_string(pal, pal, sizeof(pal), 0644);
>  module_param_string(secam, secam, sizeof(secam), 0644);


