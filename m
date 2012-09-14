Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758370Ab2INIJn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 04:09:43 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:60035 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758155Ab2INIJi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 04:09:38 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Anton Vorontsov <anton.vorontsov@linaro.org>
Subject: Re: Implement devicetree support for AB8500 Btemp
Date: Fri, 14 Sep 2012 08:09:30 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: Rajanikanth HV <rajanikanth.hv@stericsson.com>,
        Rajanikanth HV <rajanikanth.hv@linaro.org>,
        Lee Jones <lee.jones@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        "STEricsson_nomadik_linux" <STEricsson_nomadik_linux@list.st.com>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        Patch Tracking <patches@linaro.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>
References: <CAB4BAktQz5MY_AHHWUAhRp7HtEzC3v8uFbP0enx1b7ibJLoZ4Q@mail.gmail.com> <201209131437.38666.arnd@arndb.de> <20120914020427.GA30729@lizard>
In-Reply-To: <20120914020427.GA30729@lizard>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201209140809.31045.arnd@arndb.de>
X-Provags-ID: V02:K0:dlvtMNgKd/XxvXetwqj/+u5ZWlTizWoMIRPpyKD2fxP
 MfbQhAZcicNPzS2qFO2SQ7n0XW8oVwwht0vHLhswNKAEHs9EIJ
 uZKAXNYS3dTSsJtUJPsIbPDKIQAuRdhPDdfQ9JLyrEwwg7QXc4
 oWsVotUG8ld0BQmguya486PwMDdLkhjgnJ7hrGrzjN/eJPKbP9
 Rne8vhxmwqnbKXO0sbPMdd1KV2LbO+9LvL1sk65xesg0QU/sOx
 0a2lEmBBXKJrDse5wgrFPKXqRwsCHOpiIV+qKrHNHtY9W/VZit
 CiI/JjOsdRUjGb3/QKEM1XQWfjO9a8496QRs9qYt/3USU5gnIb
 gYQOgeJbXqRjpkoAKFdw=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 14 September 2012, Anton Vorontsov wrote:
> Power supply subsystem's supplied_to describes not just how driver
> should notify other devices, supplied_to is more generic stuff, in terms
> that it describes power supply hierarchy. It's like a directed graph,
> e.g.:
> 
>       <AC power> supplied_to <main battery> and <backup battery>
>      <USB power> supplied_to <main battery> and <backup battery>
>   <main battery> supplied_to <system>
> <backup battery> supplied_to <system>
>   <cmos battery> supplied_to <southbridge pci device>
>   <mice battery> supplied_to <mice wireless hid>
> 
> How things interact in linux are just implementations details.
> So, device tree is surely a perfect place to describe these things.
> 
> Although, in current bindings I see this:
> 
> +       ab8500-fg {
> +               /* Other enery management module */
> +               supplied_to = "ab8500_chargalg", "ab8500_usb";
> +               num_supplicants = <2>;
> +       };
> 
> Instead of addressing supplicants by name, it's better to address
> via phandles. And, of course, num_supplicants is not needed, it can
> be derived.

Right. that's what I thought. The other comment I made initially is
that it would be more in the spirit of the existing bindings to have
the supply property in the opposite directory, if we need it, like
(picking up your above example):


/ {
	/* power supply property in the root node is used by default */
	power-supply = <&main-battery>, <&backup-battery>;

	ac-power: power@... {
		...
	};

	usb-power: power@... {
		...
	};

	main-battery: battery@... {
		power-supply = <&ac-power>, <&usb-power};
	;

	...
};

It's the same information and absolutely equivalent as far as I can tell,
but it feel more logical in the way we tend to describe things.

	Arnd
