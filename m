Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751926Ab1GUJyH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 05:54:07 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:45580 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751318Ab1GUJyD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 05:54:03 -0400
Date: Thu, 21 Jul 2011 10:56:56 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Eric Andersson <eric.andersson@unixphere.com>
Cc: dmitry.torokhov@gmail.com, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, zhengguang.guo@bosch-sensortec.com,
        stefan.nilsson@unixphere.com,
        Albert Zhang <xu.zhang@bosch-sensortec.com>
Subject: Re: [PATCH v4 1/1] input: add driver for Bosch Sensortec's BMA150
 accelerometer
Message-ID: <20110721105656.1d579b0b@lxorguk.ukuu.org.uk>
In-Reply-To: <1311203359-23779-2-git-send-email-eric.andersson@unixphere.com>
References: <1311203359-23779-1-git-send-email-eric.andersson@unixphere.com>
	<1311203359-23779-2-git-send-email-eric.andersson@unixphere.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Only detail thing I see is this trivial one:

> +static int bma150_open(struct bma150_data *bma150)
> +{
> +	int ret = bma150_set_mode(bma150->client, BMA150_MODE_NORMAL);
> +	msleep(2);
> +	return ret;

Does the msleep here need to be inside the mutex lock for the IRQ
case ?

Otherwise it looks good except that the lack of runtime pm means it'll
stop the rest of the bus heirarchy from suspending and breaks
suspend/resume on runtime_pm based systems. I think we still need runtime
pm taking the pm reference on the input open dropping it on the close and
that's about it ? That will be sufficient to let the i2c bus controller
also runtime suspend/resume.

Not so sure about the sysfs drop - but I think its probably the right
thing for upstream and any long term 'we need a fancy driver' would be
via IIO which would sort all the interface problems.

Alan
