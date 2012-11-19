Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752251Ab2KSMy3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 07:54:29 -0500
Received: from hotel311.server4you.de ([85.25.146.15]:50226 "EHLO
	hotel311.server4you.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751670Ab2KSMy2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 07:54:28 -0500
Message-ID: <50AA2C02.1000702@monom.org>
Date: Mon, 19 Nov 2012 13:54:26 +0100
From: Daniel Wagner <wagi@monom.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: serge.hallyn@canonical.com, ebiederm@xmission.com, nhorman@tuxdriver.com,
        tgraf@suug.ch, davem@davemloft.net, lizefan@huawei.com,
        cgroups@vger.kernel.org, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] netcls_cgroup: introduce cgroup_cls_state->is_local
References: <1353123062-23193-1-git-send-email-tj@kernel.org> <1353123062-23193-3-git-send-email-tj@kernel.org>
In-Reply-To: <1353123062-23193-3-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,

On 17.11.2012 04:31, Tejun Heo wrote:
> -static int write_classid(struct cgroup *cgrp, struct cftype *cft, u64 value)
> +static int write_classid(struct cgroup *cgrp, struct cftype *cft,
> +			 const char *buf)
>   {
> +	struct cgroup_cls_state *cs = cgrp_cls_state(cgrp);
> +	s64 v;
> +
> +	if (sscanf(buf, "%lld", &v) != 1)
> +		return -EINVAL;
> +

This changes the user API slightly. cgroup_write_u64() uses 
simple_stroull() to parse the string. simple_stroull() allows to use 
either 0x1234 or 1234 as input. sscanf() will only handle the later type 
of input.

I noticed this because my test script stopped working:

    mkdir /sys/fs/cgroup/net_cls/a
    echo 0x100002 > /sys/fs/cgroup/net_cls/a/net_cls.classid # 10:2

    tc qdisc add dev $DEV root handle 10: htb
    tc class add dev $DEV parent 10: classid 10:2 htb rate 1mbit
    tc qdisc add dev $DEV parent 10:2 handle 20: sfq perturb 10

I am not completely sure if my setup is 100% correct, but at least
it seems to make something :)

cheers,
daniel

