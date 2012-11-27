Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758057Ab2K0Gs7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 01:48:59 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:14639 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755574Ab2K0Gs5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 01:48:57 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Mon, 26 Nov 2012 22:48:52 -0800
Message-ID: <50B46336.8030605@nvidia.com>
Date: Tue, 27 Nov 2012 08:52:38 +0200
From: =?ISO-8859-1?Q?Terje_Bergstr=F6m?= <tbergstrom@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Dave Airlie <airlied@gmail.com>
CC: "thierry.reding@avionic-design.de" <thierry.reding@avionic-design.de>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arto Merilainen <amerilainen@nvidia.com>
Subject: Re: [RFC v2 8/8] drm: tegra: Add gr2d device
References: <1353935954-13763-1-git-send-email-tbergstrom@nvidia.com> <1353935954-13763-9-git-send-email-tbergstrom@nvidia.com> <CAPM=9tzvt3J6D3zLPV97w629q62CNhAxX8V+_JZ6kmXxxz5fVg@mail.gmail.com>
In-Reply-To: <CAPM=9tzvt3J6D3zLPV97w629q62CNhAxX8V+_JZ6kmXxxz5fVg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27.11.2012 00:15, Dave Airlie wrote:
>>  static int tegra_drm_open(struct drm_device *drm, struct drm_file *filp)
>>  {
>> -       return 0;
>> +       struct tegra_drm_fpriv *fpriv;
>> +       int err = 0;
>> +
>> +       fpriv = kzalloc(sizeof(*fpriv), GFP_KERNEL);
>> +       if (!fpriv)
>> +               return -ENOMEM;
>> +
>> +       INIT_LIST_HEAD(&fpriv->contexts);
>> +       filp->driver_priv = fpriv;
>> +
> 
> who frees this?

Probably nobody. Will fix.

>> +struct tegra_drm_syncpt_incr_args {
>> +       __u32 id;
>> +};
> 
> add 32-bits of padding here
> 
>> +
>> +struct tegra_drm_syncpt_wait_args {
>> +       __u32 id;
>> +       __u32 thresh;
>> +       __s32 timeout;
>> +       __u32 value;
>> +};
>> +
>> +#define DRM_TEGRA_NO_TIMEOUT   (-1)
>> +
>> +struct tegra_drm_open_channel_args {
>> +       __u32 class;
>> +       void *context;
> 
> no pointers use u64, align them to 64-bits, so 32-bits of padding,

I'll add the paddings and change pointers to u64's to all of the structs
in this file.

> i'll look at the rest of the patches, but I need to know what commands
> can be submitted via this interface and what are the security
> implications of it.

All of the commands are memory operations (copy, clear, rotate, etc)
involving either one or two memory regions that are defined via dmabuf
fd's and offsets. The commands can also contain plain device virtual
addresses and 2D would be happy to oblige as long as the memory is
mapped to it.

There are a few ways to help the situation. None of them are perfect.

On Tegra30 we could allocate an address space per process. This would
mean that max 3 processes would be able to use the 2D unit at one time,
assuming that other devices are find using the one remaining address
space. On Tegra20 this is not an option.

Second would be using device permissions - only allow selected processes
to access 2D.

Third would be having a firewall in 2D driver checking the stream and
ensuring all registers that accept addresses are written by values
derived from dmabufs. I haven't tried implementing this, but it'd
involve a lookup table in kernel and CPU reading through the command
stream. Offsets and sizes would also need to be validated. There would
be a performance hit.

Fourth would be to move the creation of streams to kernel space. That'd
mean moving the whole 2D driver and host1x command stream handling to
kernel space and quite a lot of time spent in kernel. I'm not too keen
on this for obvious reasons.

Other ideas are obviously welcome.

Thanks!

Terje
