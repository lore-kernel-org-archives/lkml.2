Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755589Ab2KZQ4R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 11:56:17 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:40206 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755109Ab2KZQ4P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 11:56:15 -0500
Date: Mon, 26 Nov 2012 08:56:09 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        spear-devel@list.st.com, Vipul Kumar Samar <vipulkumar.samar@st.com>
Subject: Re: [PATCH 2/3] Input: spear-keyboard: Add clk_{un}prepare() support
Message-ID: <20121126165609.GC14623@core.coreip.homeip.net>
References: <9f07bb7dbf29978970d901bbe89add0a333cc925.1352381962.git.viresh.kumar@linaro.org>
 <27d9eea3815593df228c85958096bc14d7985e7e.1352381962.git.viresh.kumar@linaro.org>
 <CAKohpomky4s0OBYtQhDTZc9OeSo6w_mN9uAqUXpukqR1icvKPA@mail.gmail.com>
 <CAKohpoknJqMzro4gbTH+Rh=T2Bc9ZOVmDbYZsqC4Fjq2Sqsszg@mail.gmail.com>
 <20121120084758.GA29199@core.coreip.homeip.net>
 <CAKohpon44N8uhEiPEp0Sp8rKAE597Y8A3-YsRFTAZZz4XE8hDw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKohpon44N8uhEiPEp0Sp8rKAE597Y8A3-YsRFTAZZz4XE8hDw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 26, 2012 at 09:57:45PM +0530, Viresh Kumar wrote:
> On 20 November 2012 14:17, Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:
> > No, not really, it just does not work well with devm_* patches that got
> > applied: on removal you unprepare clock as the very first operation and
> > then devm_* does the rest which is wrong order.
> >
> > I am looking at adding dem_* for clocks.
> 
> I haven't seen your clock patch in your tree. I am asking because i want to
> push this patch :)

Yeah, I think I am not going to rush it and let it take its normal
course instead of short-cutting through my tree. I am going to apply the
patcch below in the meantime.

Thanks.

-- 
Dmitry


Input: spear-keyboard - Add clk_{un}prepare() support

From: Vipul Kumar Samar <vipulkumar.samar@st.com>

clk_{un}prepare is mandatory for platforms using common clock framework.
Because for SPEAr we don't do anything in clk_{un}prepare() calls, just
call them once in probe/remove.

Signed-off-by: Vipul Kumar Samar <vipulkumar.samar@st.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---
 drivers/input/keyboard/spear-keyboard.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/input/keyboard/spear-keyboard.c b/drivers/input/keyboard/spear-keyboard.c
index d70093b..695d237 100644
--- a/drivers/input/keyboard/spear-keyboard.c
+++ b/drivers/input/keyboard/spear-keyboard.c
@@ -267,9 +267,14 @@ static int spear_kbd_probe(struct platform_device *pdev)
 		return error;
 	}
 
+	error = clk_prepare(kbd->clk);
+	if (error)
+		return error;
+
 	error = input_register_device(input_dev);
 	if (error) {
 		dev_err(&pdev->dev, "Unable to register keyboard device\n");
+		clk_unprepare(kbd->clk);
 		return error;
 	}
 
@@ -281,6 +286,11 @@ static int spear_kbd_probe(struct platform_device *pdev)
 
 static int spear_kbd_remove(struct platform_device *pdev)
 {
+	struct spear_kbd *kbd = platform_get_drvdata(pdev);
+
+	input_unregister_device(kbd->input);
+	clk_unprepare(kbd->clk);
+
 	device_init_wakeup(&pdev->dev, 0);
 	platform_set_drvdata(pdev, NULL);
 
