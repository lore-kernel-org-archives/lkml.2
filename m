Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932748Ab0C3X0U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 19:26:20 -0400
Received: from p01c11o142.mxlogic.net ([208.65.144.65]:54171 "EHLO
	p01c11o142.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932703Ab0C3X0Q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:26:16 -0400
X-MXL-Hash: 4bb288981d5517c8-4fba9aac31cc4ad9324e5b9fb216c0531be2a022
X-MXL-Hash: 4bb28865150d0ac3-f57aa32e7e04845577d2af58a7afceb1cd30d01c
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Andrew Morton <akpm@linux-foundation.org>, InKi Dae <daeinki@gmail.com>
CC: "kyungmin.park@samsung.com" <kyungmin.park@samsung.com>,
       "linux-fbdev-devel@lists.sourceforge.net" 
	<linux-fbdev-devel@lists.sourceforge.net>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Pavel Machek <pavel@ucw.cz>
Date: Tue, 30 Mar 2010 18:24:51 -0500
Subject: RE: [Linux-fbdev-devel] [PATCH] added S6E63M0 AMOLED LCD Panel
	driver.
Thread-Topic: [Linux-fbdev-devel] [PATCH] added S6E63M0 AMOLED LCD Panel
	driver.
Thread-Index: AcrQXUmoYAAXDTbkQmOViSr8TtxIOAAAVUvg
Message-ID: <0D753D10438DA54287A00B027084269763691C3440@AUSP01VMBX24.collaborationhost.net>
References: <90b950fc1003252024i5ba8989bg95f0a81e8e5e708e@mail.gmail.com>
 <20100330160257.e5f978a9.akpm@linux-foundation.org>
In-Reply-To: <20100330160257.e5f978a9.akpm@linux-foundation.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Spam: [F=0.2000000000; CM=0.500; S=0.200(2010032501)]
X-MAIL-FROM: <hartleys@visionengravers.com>
X-SOURCE-IP: [216.166.12.31]
X-AnalysisOut: [v=1.0 c=1 a=mkeGiTlneQQA:10 a=VphdPIyG4kEA:10 a=kj9zAlcOel]
X-AnalysisOut: [0A:10 a=qS3xps/WtSuafY8lc/WARg==:17 a=pGLkceISAAAA:8 a=H8A]
X-AnalysisOut: [gYNB9rK2gjXRbEzgA:9 a=PgU1wk1LBmWQeK63oP9ZZVqfz8wA:4 a=Cju]
X-AnalysisOut: [IK1q_8ugA:10 a=MSl-tDqOz04A:10]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, March 30, 2010 4:03 PM, Andrew Morton wrote:
> On Fri, 26 Mar 2010 12:24:24 +0900
> InKi Dae <daeinki@gmail.com> wrote:
> 
>> +static int s6e63m0_ldi_init(struct s6e63m0 *lcd)
>> +{
>> +	int ret;
>> +
>> +	ret = s6e63m0_panel_send_sequence(lcd, SEQ_PANEL_CONDITION_SET);
>> +	ret |= s6e63m0_panel_send_sequence(lcd, SEQ_DISPLAY_CONDITION_SET);
>> +	ret |= s6e63m0_panel_send_sequence(lcd, SEQ_GAMMA_SETTING);
>> +	ret |= s6e63m0_panel_send_sequence(lcd, SEQ_ETC_CONDITION_SET);
>> +	ret |= s6e63m0_panel_send_sequence(lcd, SEQ_ACL_ON);
>> +	ret |= s6e63m0_panel_send_sequence(lcd, SEQ_ELVSS_ON);
>> +
>> +	return ret;
>> +}
>
> Well.  If one call to s6e63m0_panel_send_sequence() returns -ENOMEM and
> another call returns -EIO (for example), this function will return some
> other, incorrect errno.
>
> Which is a rather minor problem, unless some caller is explicitly
> looking for some particular error code, which doesn't happen often.

Why not handle the calls with a loop?

+static int s6e63m0_ldi_init(struct s6e63m0 *lcd)
+{
+	const unsigned short *init_seq[] = {
+		SEQ_PANEL_CONDITION_SET,
+		SEQ_DISPLAY_CONDITION_SET,
+		SEQ_GAMMA_SETTING,
+		SEQ_ETC_CONDITION_SET,
+		SEQ_ACL_ON,
+		SEQ_ELVSS_ON,
+	};
+	int i, ret;
+
+	for (i = 0; i < ARRAY_SIZE(init_seq); i++) {
+		ret = s6e63m0_panel_send_sequence(lcd, init_seq[i]);
+		if (ret)
+			break;
+	}
+	return ret;
+}

Note that _s6e63m0_gamma_ctl has the same issue.  Actually, the whole
driver has issues with returning errors properly.

Regards,
Hartley