Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753412Ab2A1EbH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 23:31:07 -0500
Received: from he.sipsolutions.net ([78.46.109.217]:45082 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752244Ab2A1EbF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 23:31:05 -0500
Message-ID: <4F2379E6.9050303@sipsolutions.net>
Date: Fri, 27 Jan 2012 20:30:30 -0800
From: Johannes Berg <johannes@sipsolutions.net>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: LKML <linux-kernel@vger.kernel.org>,
        wireless <linux-wireless@vger.kernel.org>
Subject: Re: Kernel BUG due to kernel page fault
References: <4F21D57F.7090103@lwfinger.net> (sfid-20120126_233645_796686_E4D04A53)
In-Reply-To: <4F21D57F.7090103@lwfinger.net> (sfid-20120126_233645_796686_E4D04A53)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Larry,

On 1/26/2012 2:36 PM, Larry Finger wrote:
> I am trying to convert the rtlwifi family of drivers to use asynchronous
> firmware loading. With recent changes in udev, many problems are being
> reported. See Bug 42632] at b.k.o.

I'm not sure what caused your problem, but your email reminded me of an 
issue we had with asynchronous firmware loading that you may want to 
consider.

When request_firmware_async() is called, it eventually calls the 
callback you give it. This may, however, be a long time later (I think 
the current default timeout is 1 minute). In the meantime, the module 
could be unloaded by the user, and then the system crashes as soon as 
the firmwaer code attempts to invoke the callback.

To fix this, we have a completion in iwlwifi that some exit code path 
waits for to make sure this scenario doesn't happen.

I think you should implement that.

A better fix would probably be to make request_firmware_async() take a 
struct module * argument and pass THIS_MODULE to it, and make the 
firmware code handle this, but currently it doesn't.

johannes
