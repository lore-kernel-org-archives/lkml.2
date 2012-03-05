Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757219Ab2CERkQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 12:40:16 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:39101 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755948Ab2CERkN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 12:40:13 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of ddaney.cavm@gmail.com designates 10.236.161.232 as permitted sender) smtp.mail=ddaney.cavm@gmail.com; dkim=pass header.i=ddaney.cavm@gmail.com
Message-ID: <4F54FA79.9030608@gmail.com>
Date: Mon, 05 Mar 2012 09:40:09 -0800
From: David Daney <ddaney.cavm@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: linux-kernel@vger.kernel.org, Tony Lindgren <tony@atomide.com>,
        Greg Kroah-Hartman <greg@kroah.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Arnd Bergmann <arnd@arndb.de>, Dilan Lee <dilee@nvidia.com>,
        Manjunath GKondaiah <manjunath.gkondaiah@linaro.org>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] drivercore: Add driver probe deferral mechanism
References: <1330962461-9061-1-git-send-email-grant.likely@secretlab.ca>
In-Reply-To: <1330962461-9061-1-git-send-email-grant.likely@secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/05/2012 07:47 AM, Grant Likely wrote:
> Allow drivers to report at probe time that they cannot get all the resources
> required by the device, and should be retried at a later time.
>
> This should completely solve the problem of getting devices
> initialized in the right order.  Right now this is mostly handled by
> mucking about with initcall ordering which is a complete hack, and
> doesn't even remotely handle the case where device drivers are in
> modules.  This approach completely sidesteps the issues by allowing
> driver registration to occur in any order, and any driver can request
> to be retried after a few more other drivers get probed.
>
> v4: - Integrate Manjunath's addition of a separate workqueue
>      - Change -EAGAIN to -EPROBE_DEFER for drivers to trigger deferral
>      - Update comment blocks to reflect how the code really works
> v3: - Hold off workqueue scheduling until late_initcall so that the bulk
>        of driver probes are complete before we start retrying deferred devices.
>      - Tested with simple use cases.  Still needs more testing though.
>        Using it to get rid of the gpio early_initcall madness, or to replace
>        the ASoC internal probe deferral code would be ideal.
> v2: - added locking so it should no longer be utterly broken in that regard
>      - remove device from deferred list at device_del time.
>      - Still completely untested with any real use case, but has been
>        boot tested.
>
> Signed-off-by: Grant Likely<grant.likely@secretlab.ca>

Hi Grant, thanks for working on this:

Acked-by: David Daney <david.daney@cavium.com>

> Cc: Greg Kroah-Hartman<greg@kroah.com>
> Cc: Mark Brown<broonie@opensource.wolfsonmicro.com>
> Cc: Arnd Bergmann<arnd@arndb.de>
> Cc: Dilan Lee<dilee@nvidia.com>
> Cc: Manjunath GKondaiah<manjunath.gkondaiah@linaro.org>
> Cc: Alan Stern<stern@rowland.harvard.edu>
> Cc: Tony Lindgren<tony@atomide.com>
> ---
>
> Hi Greg,
>
> This has been through several revisions now and I think it's ready to go
> in.  The summary from the last discussion is that users need to have the
> dpm_list order adjusted if they defer themselves, but that is something
> which just cannot be performed by the core code (It needs to be manipulated
> mid-probe() call).
>
> I know that not everybody is happy with this approach, but I've yet to
> see a better alternative.  However, it is *really easy* to find all the
> users of deferred probe since any user must return -EPROBE_DEFER explicitly.
> If/when a better approach is found, all the users will be easy to find
> and modify.
>
> If this patch is not merged, then I'm going to have to merge another round
> of patches that futz with initcall ordering to get some drivers to probe
> correctly.  :-(
>
> g.
>
>   drivers/base/base.h    |    1 +
>   drivers/base/core.c    |    2 +
>   drivers/base/dd.c      |  138 +++++++++++++++++++++++++++++++++++++++++++++++-
>   include/linux/device.h |    5 ++
>   include/linux/errno.h  |    1 +
>   5 files changed, 146 insertions(+), 1 deletions(-)
>

