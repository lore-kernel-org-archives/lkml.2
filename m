Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754679Ab2LCCDb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2012 21:03:31 -0500
Received: from relay.ihostexchange.net ([66.46.182.52]:30227 "EHLO
	relay.ihostexchange.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754359Ab2LCCDa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2012 21:03:30 -0500
X-Greylist: delayed 306 seconds by postgrey-1.27 at vger.kernel.org; Sun, 02 Dec 2012 21:03:30 EST
From: Dudley Du <dudl@cypress.com>
To: Kamal Mostafa <kamal@canonical.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>
CC: David Solda <dso@cypress.com>, Troy Abercrombia <ta@cypress.com>,
        customercare <customercare@cypress.com>,
        Kyle Fazzari <git@status.e4ward.com>,
        Mario Limonciello <mario_limonciello@dell.com>,
        Tim Gardner <tim.gardner@canonical.com>,
        Herton Krzesinski <herton.krzesinski@canonical.com>
Date: Sun, 2 Dec 2012 20:58:17 -0500
Subject: RE: [PATCH v3 4/4] input: Cypress PS/2 Trackpad simulated multitouch
Thread-Topic: [PATCH v3 4/4] input: Cypress PS/2 Trackpad simulated
 multitouch
Thread-Index: Ac3OfJzW7z9gs6VuTS+FIGk0Xldq9ACfFoXg
Message-ID: <B27AC323FA92C946BA36D2913DDC8E370234D97E4987@VMBX126.ihostexchange.net>
References: <1354226281-3476-1-git-send-email-kamal@canonical.com>
 <1354226281-3476-5-git-send-email-kamal@canonical.com>
In-Reply-To: <1354226281-3476-5-git-send-email-kamal@canonical.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: zh-CN, en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Instead of SEMI_MT, present a full mt interface with simulated contact positions for >=3 fingers.  Enables e.g. multi-finger tap and drag.
>
> Signed-off-by: Kamal Mostafa <kamal@canonical.com>
> ---
>  drivers/input/mouse/cypress_ps2.c |   16 ++++++++++++++++
>  drivers/input/mouse/cypress_ps2.h |   14 +++++++++++++-
>  2 files changed, 29 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/input/mouse/cypress_ps2.c b/drivers/input/mouse/cypress_ps2.c
> index 472342a..bbaa9b9 100644
> --- a/drivers/input/mouse/cypress_ps2.c
> +++ b/drivers/input/mouse/cypress_ps2.c
> @@ -408,7 +408,9 @@ static int cypress_set_input_params(struct input_dev *input,
>                       return ret;
>               }
>
> +#if ( CYPRESS_SIMULATED_MT != 1 )
>               __set_bit(INPUT_PROP_SEMI_MT, input->propbit);
> +#endif
>
>               if (cytp->tp_res_x && cytp->tp_res_x) {


Here, should be "if (cytp->tp_res_x && cytp->tp_res_y) {".
And since cytp->tp_max_abs_y read from trackpad maybe zero, so we should better double check here.


>                       input_abs_set_res(input, ABS_X, cytp->tp_res_x); @@ -531,6 +533,20 @@ static int cypress_parse_packet(struct psmouse *psmouse,
>                               ((packet[5] & 0x0f) << 8) | packet[7];
>                       if (cytp->mode & CYTP_BIT_ABS_PRESSURE)
>                               report_data->contacts[1].z = report_data->contacts[0].z;
> +#if ( CYPRESS_SIMULATED_MT == 1 )
> +                     /* simulate contact positions for >2 fingers */
> +                     if ( report_data->contact_cnt >= 3 )
> +                             for ( i=1; i<report_data->contact_cnt; i++ ) {
> +                                 report_data->contacts[i].x =
> +                                                 report_data->contacts[0].x
> +                                                 + 100*(i)*((i%2)?-1:1);
> +                                 report_data->contacts[i].y =
> +                                                 report_data->contacts[0].y;
> +                                 if (cytp->mode & CYTP_BIT_ABS_PRESSURE)
> +                                         report_data->contacts[i].z =
> +                                                 report_data->contacts[0].z;
> +                             }
> +#endif
>               }
>
>               report_data->left = (header_byte & BTN_LEFT_BIT) ? 1 : 0; diff --git a/drivers/input/mouse/cypress_ps2.h b/drivers/input/mouse/cypress_ps2.h
> index ce70462..4b903a9 100644
> --- a/drivers/input/mouse/cypress_ps2.h
> +++ b/drivers/input/mouse/cypress_ps2.h
> @@ -134,7 +134,19 @@
>  #define RESP_SMBUS_BIT      0x80
>
>  #define CYTP_MAX_CONTACTS 5
> -#define CYTP_MAX_MT_SLOTS 2
> +
> +/*
> + * CYPRESS_SIMULATED_MT
> + *   set to 1 for simulated multitouch (up to CTYP_MAX_CONTACTS fingers)
> + *   set to 0 for SEMI_MT (2 fingers only)
> + */
> +#define CYPRESS_SIMULATED_MT 1
> +
> +#if ( CYPRESS_SIMULATED_MT == 1 )
> +# define CYTP_MAX_MT_SLOTS 16
> +#else
> +# define CYTP_MAX_MT_SLOTS 2
> +#endif
>
>  enum cytp_type {
>       CYTP_STG,
> --
> 1.7.10.4


This message and any attachments may contain Cypress (or its subsidiaries) confidential information. If it has been received in error, please advise the sender and immediately delete this message.
