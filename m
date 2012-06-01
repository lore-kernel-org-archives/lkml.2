Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932343Ab2FAIzQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 04:55:16 -0400
Received: from plane.gmane.org ([80.91.229.3]:60620 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759157Ab2FAIzO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 04:55:14 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Yi Zhang <zhangyi.hust@gmail.com>
Subject: Re: [PATCH] regulator: gpio-regulator: Set the smallest voltage/current in the specified range
Date: Fri, 1 Jun 2012 08:45:33 +0000 (UTC)
Message-ID: <loom.20120601T103409-573@post.gmane.org>
References: <1332396484.3842.2.camel@phoenix> <20120322115009.GG3091@opensource.wolfsonmicro.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: sea.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 210.13.71.73 (Mozilla/5.0 (Windows NT 6.1) AppleWebKit/536.5 (KHTML, like Gecko) Chrome/19.0.1084.52 Safari/536.5)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Brown <broonie <at> opensource.wolfsonmicro.com> writes:

> 
> On Thu, Mar 22, 2012 at 02:08:04PM +0800, Axel Lin wrote:
> > Do not assume the gpio regulator states map is sorted in any order.
> > This patch ensures we always set the smallest voltage/current that falls 
within
> > the specified range.
> 
> Applied, thanks.
> 

 	struct gpio_regulator_data *data = rdev_get_drvdata(dev);
-	int ptr, target, state;
+	int ptr, target, state, best_val = INT_MAX;

-	target = -1;
 	for (ptr = 0; ptr < data->nr_states; ptr++)
-		if (data->states[ptr].value >= min &&
+		if (data->states[ptr].value < best_val &&
+		    data->states[ptr].value >= min &&
 		    data->states[ptr].value <= max)
 			target = data->states[ptr].gpios;

-	if (target < 0)
+	if (best_val == INT_MAX)

Here seems something wrong, for best_val is always INT_MAX. From the discussion 
above, maybe best_val is should be reassigned in the for loop.
It may be like as the following:

-       for (ptr = 0; ptr < data->nr_states; ptr++)
+       for (ptr = 0; ptr < data->nr_states; ptr++) {
                if (data->states[ptr].value < best_val &&
                    data->states[ptr].value >= min &&
-                   data->states[ptr].value <= max)
+                   data->states[ptr].value <= max) {
                        target = data->states[ptr].gpios;
+                       best_val = target;
+       }

What do you think? thanks;


