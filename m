Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756797Ab2IUCYE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 22:24:04 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:48141 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755899Ab2IUCYB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 22:24:01 -0400
MIME-version: 1.0
Content-transfer-encoding: 8BIT
Content-type: text/plain; charset=EUC-KR
X-AuditID: cbfee61b-b7f2b6d000000f14-84-505bcfbfe373
Message-id: <505BCFB3.3040004@samsung.com>
Date: Fri, 21 Sep 2012 11:23:47 +0900
From: jonghwa3.lee@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216
 Thunderbird/10.0.2
To: Amit Daniel Kachhap <amit.kachhap@linaro.org>
Cc: linux-pm@lists.linux-foundation.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Zhang Rui <rui.zhang@intel.com>, Len Brown <lenb@kernel.org>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: Re: [PATCH v6 1/6] thermal: add generic cpufreq cooling implementation
References: <0MAO00DCVFKI4NS0@ms2.samsung.com>
In-reply-to: <0MAO00DCVFKI4NS0@ms2.samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrALMWRmVeSWpSXmKPExsVy+t9jAd0D56MDDNYtZLRYvq+f0eLyrjls
	FjPO72NyYPb4vEkugDGKyyYlNSezLLVI3y6BK+Nxj3jBOf6K17N2MzcwHuHuYuTkkBAwkfj/
	bRczhC0mceHeerYuRi4OIYFFjBLzOzaAJXgFBCV+TL7H0sXIwcEsIC9x5FI2SJhZQENi6uvT
	jBD1LxklVi65wQ5RryUx4eFhVhCbRUBVYs20ZSwgNpuAnMTbpm+MIHNEBSIkfvVzgJgiAoYS
	/z7kg4xhFpjAJLGneTsTSLmwgL/Exl8/wMYICehJfJt3GyzOKaAv0TH9A9sERoFZSK6bhXDd
	LCTXLWBkXsUomlqQXFCclJ5rpFecmFtcmpeul5yfu4kRHI7PpHcwrmqwOMQowMGoxMNb7x4d
	IMSaWFZcmXuIUYKDWUmE91EMUIg3JbGyKrUoP76oNCe1+BCjNAeLkjiv8KfAACGB9MSS1OzU
	1ILUIpgsEwenVAOj+oS68t6O1pk1EX5Xu/f5Hn8UX5S/Lebx9rn8F8xF9oW+zDabYaQcYLLi
	/OWdKgERftvfN8hf0zK9MHv/sTU2m3V3GbYsUeK89ir28MkonlSPE9lKG/i19rf+PW1xvaVK
	uTToxhN+yz2+SUGlPCWZfHO4k576dB7RCkhesq5GnSs9orn3bYYSS3FGoqEWc1FxIgA4pEd/
	QwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Amit,
On 2012³â 08¿ù 16ÀÏ 20:41, Amit Daniel Kachhap wrote:

>  diff --git a/drivers/thermal/cpu_cooling.c b/drivers/thermal/cpu_cooling.c
>  new file mode 100644
>  index 0000000..66cbd52
>  --- /dev/null
>  +++ b/drivers/thermal/cpu_cooling.c
>  @@ -0,0 +1,586 @@

>  +/**
>  + * cpufreq_cooling_register - function to create cpufreq cooling device.
>  + * @clip_cpus: cpumask of cpus where the frequency constraints will happen.
>  + */
>  +struct thermal_cooling_device *cpufreq_cooling_register(
>  +       struct cpumask *clip_cpus)
>  +{
>  +       struct thermal_cooling_device *cool_dev;
>  +       struct cpufreq_cooling_device *cpufreq_dev = NULL;
>  +       unsigned int cpufreq_dev_count = 0, min = 0, max = 0;
>  +       char dev_name[THERMAL_NAME_LENGTH];
>  +       int ret = 0, id = 0, i;
>  +       struct cpufreq_policy policy;
>  +       ret = get_idr(&cpufreq_idr,&cpufreq_dev->id);
>  +       if (ret) {
>  +               kfree(cpufreq_dev);
>  +               return ERR_PTR(-EINVAL);
>  +       }
>  +
>  +       sprintf(dev_name, "thermal-cpufreq-%d", cpufreq_dev->id);
>  +
>  +       cool_dev = thermal_cooling_device_register(dev_name, cpufreq_dev,
>  +&cpufreq_cooling_ops);
>  +       if (!cool_dev) {
>  +               release_idr(&cpufreq_idr, cpufreq_dev->id);
>  +               kfree(cpufreq_dev);
>  +               return ERR_PTR(-EINVAL);
>  +       }
>  +       cpufreq_dev->id = id;


Why is this needed? Should every cpufreq_dev instance's id be same for
zero? It looks odd. And it also has problem which can be occurred when
it release id during unregistering cpufreq_dev. I think it should keep
the idr value taken before.


>  1.7.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


