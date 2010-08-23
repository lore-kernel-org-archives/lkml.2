Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754172Ab0HWPpM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 11:45:12 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:43054 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754117Ab0HWPpK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 11:45:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type;
        b=ELyfMbct0LESyjjCyUKdV1etkEYcwOWGFgZ9+bDkHQStQSWqGB+ng9INsUZDk80EIZ
         gQoKs3ZOxI65TvgWI2/lJc0xjXmNj2YL+SWte7dZNNBbAb1s5BHg5YkrM/LUBdrfG+hd
         cEZYu5szIUfr/TgYCJhK3Jj0DyzRdE+W3OG38=
MIME-Version: 1.0
In-Reply-To: <1282572681.3813.3.camel@jlt3.sipsolutions.net>
References: <1282350556-16523-1-git-send-email-lrodriguez@atheros.com> <1282572681.3813.3.camel@jlt3.sipsolutions.net>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Mon, 23 Aug 2010 08:44:49 -0700
X-Google-Sender-Auth: iPEYgkhQDKUseA21yAae2MINEoQ
Message-ID: <AANLkTimrtWQKycuAcZ3SjDaOqJ6Z-pPNauRfh+2aZ=ge@mail.gmail.com>
Subject: Re: [PATCH 0/2] iw: add GeoClue support
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, geoclue@lists.freedesktop.org,
        David.Quan@atheros.com, kevin@atheros.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 23, 2010 at 7:11 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Fri, 2010-08-20 at 20:29 -0400, Luis R. Rodriguez wrote:
>> This series adds GeoClue support to iw.
>
> Quite frankly, I don't see the point?

To help us move forward to automate location awareness information
into the kernel. I don't think we can unify all possible solutions for
the different distributions out there so best is to make available
whatever utilities we can and allow the distribution implementors to
embrace whatever they want.

I'll explain some more below.

> What use is a command line tool that has to talk to a whole bunch of
> daemons etc.?

The current implementation doesn't talk to deamons. The hostip
provider within GeoClue and it will just trigger a URL get. If
desktops start implementing a master server though then the query
would simply be a cached response.

> I could see using say NM to connect it all,

GeoClue has some initial connectivity support now. It allows your
connectivity managers to provide back things like status of your
connection, your AP's MAC address, router MAC address, and a list of
APs. The last one can be used by Plazes and Skyhook for example.
GeoClue now supports this connection interface with Network Manager
and as of recently for Connman. Technically Connman and Network
Manager then can seed GeoClue with bits of info for providers. For
example I can forsee a GeoClue http://wigle.net provider implemented
where the provider can make use of the existing connection manager
services to query APs and eventually provide clients its location.

So clients are the ones querying GeoClue, and its up to them to
implement support. Network Manager and Connman can add support for
GeoClue by doing a similar query but then the question arises if all
distributions will also be providing a master provider. The GeoClue
master provider caches queries based on all supported and available
providers so that clients do not have to wait for a provider to do its
work on an independent query. If not master provider is installed on a
system, each GeoClue client will have to poke at the respective
provider to do its own work. In the case of the hostip provider a
simple URL query is made and parsed (http://api.hostip.info). For
other providers like gypsy Dbus will be used to get gypsy to do its
thing and give back information. I should also note GeoClue depends on
Glib and Dbus so there are also size considerations embedded
distributions must make if they are not supporting Glib and/or Dbus.

For distributions then the question of the master provider and
overhead library support remains. The iw patch I provide simply
provides an example of how to do this in userspace applications and I
would like to expand on it to use other providers first like Gpysy and
Gpsd until the desktop catches up. This may mean we end up handling
this in wpa_supplicant -- not sure, this would be a good time to
review this or we can also review this at the upcoming summit. For
embedded distributions like openwrt it also provides a sample of what
can be equivalently done, I doubt Glib support will be integrated.

> or maybe put it into geoclue directly,

GeoClue provides clients an API to query geolocation information. Its
up to the different distributions to decide if they want to implement
support for the master provider, which providers they want to handle.
Client software then just queries GeoClue, what we need then is
different userspace clients being capable of querying this information
if GeoClue is supported to send it off to the kernel.

> but a command line to trigger it all seems
> like a wrong approach?

Its an option which can be made available to distributions, right now
we have no other except a set of bash scripts to for example query
timezone and things like that. Piggy backing this on top of iw lets
distributions eventually replace those scripts with a simple iw call.
That should also get distributions to consider implementing the master
GeoClue provider.

The last mile IMHO, will be to figure out how the different desktops /
connection managers like Network Manager and Connman, and embedded
systems ultimately use some of this or use alternatives.

 Luis
