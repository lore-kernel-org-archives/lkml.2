Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933299Ab2FGWWx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 18:22:53 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:42952 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933212Ab2FGWWw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 18:22:52 -0400
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:1b02:1aa9:5ff:fe24:37a9]
In-Reply-To: <1338926395-26298-1-git-send-email-bfreed@chromium.org>
References: <1338926395-26298-1-git-send-email-bfreed@chromium.org>
Date: Thu, 7 Jun 2012 15:22:51 -0700
Message-ID: <CAOesGMgznrjPooqtAC6C+msk3yjBSm3OzVA-xOgkfdqAfsZ=jQ@mail.gmail.com>
Subject: Re: [PATCH] pstore/ram: Add ramoops support for the Flattened Device Tree.
From: Olof Johansson <olof@lixom.net>
To: Bryan Freed <bfreed@chromium.org>
Cc: linux-kernel@vger.kernel.org, keescook@chromium.org,
        marco.stornelli@gmail.com, grant.likely@secretlab.ca,
        anton.vorontsov@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Jun 5, 2012 at 12:59 PM, Bryan Freed <bfreed@chromium.org> wrote:
> When called with a non-zero of_node, fill out a new ramoops_platform_data
> with data from the specified Flattened Device Tree node.
> Update ramoops documentation with the new FDT interface.
>
> Change-Id: Id8f9f0abc5b564375c1b6d5d30c92d57d76520b7
> Signed-off-by: Bryan Freed <bfreed@chromium.org>
> ---
>  Documentation/ramoops.txt |   19 +++++++++++++++++--
>  fs/pstore/ram.c           |   43 +++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 60 insertions(+), 2 deletions(-)
>
> diff --git a/Documentation/ramoops.txt b/Documentation/ramoops.txt
> index 4ba7db2..9ed3ab7 100644
> --- a/Documentation/ramoops.txt
> +++ b/Documentation/ramoops.txt
> @@ -3,7 +3,7 @@ Ramoops oops/panic logger
>
>  Sergiu Iordache <sergiu@chromium.org>
>
> -Updated: 17 November 2011
> +Updated: 5 June 2012
>
>  0. Introduction
>
> @@ -37,7 +37,7 @@ corrupt, but usually it is restorable.
>
>  2. Setting the parameters
>
> -Setting the ramoops parameters can be done in 2 different manners:
> +Setting the ramoops parameters can be done in 3 different manners:
>  1. Use the module parameters (which have the names of the variables described
>  as before).
>  2. Use a platform device and set the platform data. The parameters can then
> @@ -70,6 +70,21 @@ if (ret) {
>        return ret;
>  }
>
> + 3. Use the Flattened Device Tree to set the platform data.  For example:
> +  arch/arm/boot/dts/$BOARD.dts:
> +        ramoops {
> +                compatible = "ramoops";
> +                reg = <0x41f00000 0x00100000>;
> +                record-size = <0x00020000>;
> +                dump-oops = <1>;
> +                ecc = <0>;
> +        };
> + The "reg = <0x41f00000 0x00100000>" line specifies a mem_size of 1MB at
> +  mem_address 0x41f00000.
> + The "record-size = <0x00020000>" line specifies a record size of 128KB.
> + The "dump-oops = <1>" line tells us to dump oopses as well as panics.
> + The "ecc = <0>" line tells us to turn off ECC protection.

Device tree properties are binary just by being present or not. So
there is no need to have values on these -- to turn "dump-oops" off,
don't include the property. Same for ecc.

But to take a step up, to be honest I don't think "dump-oops" belongs
here. The device tree is supposed to define hardware. In this case,
what truly needs to be defined for that is the base address, and
_possibly_ the record size used.

The rest are software attributes. For dump-oops, I propose using
sysctl/module parameters instead. That is true for ECC as well.

So, I would just remove those pieces from the device tree binding and
parsing, and focus on the memory range and record size. The rest can
be configured after booting (or on the commandline) if needed.

Also, the device-tree documentation should be added under
Documentation/devicetree/bindings as well (or maybe only there, and
referenced from the ramoops.txt docs).


Thanks!

-Olof
