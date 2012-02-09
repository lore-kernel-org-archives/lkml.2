Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757914Ab2BIPZ2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 10:25:28 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:51418 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753021Ab2BIPZ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 10:25:26 -0500
Message-ID: <4F33E5A8.2030904@linaro.org>
Date: Thu, 09 Feb 2012 07:26:32 -0800
From: Dmitry Antipov <dmitry.antipov@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120129 Thunderbird/10.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: John Stultz <john.stultz@linaro.org>, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org
Subject: Re: clock_getres() and real resolution
References: <4F32A347.4090703@linaro.org> <alpine.LFD.2.02.1202091051310.2794@ionos>
In-Reply-To: <alpine.LFD.2.02.1202091051310.2794@ionos>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/09/2012 02:12 AM, Thomas Gleixner wrote:

> It would be possible to return the real resolution of the clock event
> device, but we have systems, where the clockevent device is
> dynamically changing. So which resolution do we expose to an
> application? The one of the current active device or some magic number
> of a device which might not even be initialized? That's more confusing
> than telling user space that high resolution timers are active and the
> kernel is trying to achieve the 1ns accuracy.

First of all, it's not necessary to make unrealizable promises to
an application programmer. If it's known that _any_ hardware configuration
can't guarantee, for example, <20ns precision, it's better to return
{0, 20} than {0, 1} from clock_getres(...). If high-res subsystem
isn't active, just return -1 and set errno to EINVAL, regardless of
an arguments passed.

Second, it's very hard to deny that some applications really needs
precise time measurements. So, if the clockevent device is dynamically
changing, it would be nice to have a method to prevent the loss of
precision for such an application. For example, an application may
issue prctl(PR_SET_CLOCK_STABLE, 1) to make sure that hrtimer's resolution
isn't changed (or at least not changed with the loss of precision)
until prctl(PR_SET_CLOCK_STABLE, 0) or exit(); if some system-wide
event decreases hrtimer accuracy, such an application might receive
a signal, etc.

Dmitry
