Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758407Ab1FKATr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 20:19:47 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:63078 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758305Ab1FKATq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 20:19:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type;
        b=BC1tlR+mU7bol61UZ2JrCeErE6Sy3+uQA3IrHNb/WgPG5DLUU/wiDddVvQI7+t+T8v
         ptNr/PLjfnTmmdjznNynxMRa6cKdXOaUs+rLJi9jiaPBxYGposfxGJIy/v6L4Oq4NRWi
         R1gFS93UjgsJuQ5yag4Dvt3jz/Hvc2jvp2J9Q=
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 10 Jun 2011 17:19:25 -0700
Message-ID: <BANLkTik=t+BC4uBzXac-Gn7RjhmrnbWX6g@mail.gmail.com>
Subject: [ANN] acs: automatic channel selection utility for 802.11
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: linux-kernel@vger.kernel.org, hostap@lists.shmoo.com,
        Matt Smith <Matt.Smith@atheros.com>,
        Arun Venkataraman <arun.venkataraman@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've finished a first proof of concept on the discussed Automatic
Channel Selection effort I've discussed before [1] to help us find an
ideal channel for initiating radiation with 802.11 (AP, Mesh, P2P,
Adhoc). I've tweaked the algorithm a bit. Its a first attempt so
likely tons of flaws here but hey, its something. Feedback / test
appreciated, I haven't tested this much except for looking for some
sort of sane values computed.

Patches welcome :)

Code:

git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/acs.git

Below a description based on the last functional commit:

commit aaacb1102124723d5ced29188350cf2fe7244a5b
Author: Luis R. Rodriguez <lrodriguez@atheros.com>
Date:   Fri Jun 10 16:50:30 2011 -0700

    acs: adds initial algorithm to select ideal channel

    For each survey we assign it an "interference factor" which
    we define as:

                    (busy time - tx time)
    int_factor = ------------------------- *  3^(noise + min_noise)
                   (active time - tx time)

    The way to think about this is that the right hand deals with
    assigning the observed noise value a multiplier value. This
    multiplier will be 1 if the observed noise is the lowest observed
    on the entire spectrum, and it will be > 1 and grow exponentially
    based on powers of 3 if the noise is higher.

    The value on the left computes a ratio of the how much time
    the hardware has detected a busy (non-idle) channel over the total
    time we have spent on that channel. This gives us an interference
    ratio.

    The interference ratio is amplified by the noise factor.

    The way the program works right now is we first collect the
    list of allowed channels where we can scan. Then for each
    channel we go offchannel for 5ms and then collect a survey
    sample only for that channel, we peg it onto a linked list.
    We currently do this 10 times for each channel.

    After we've collected all surveys, we get the minimum noise
    value for all channels for all surveys. Then we compute an
    interference factor for each survey. The frequency's own
    interference factor is then computed as the sum of all of
    its own survey's interference factors.

    Optimizations here would be to do the offchannel operations,
    and survey sampling at random times instead of consecutively.
    For really low noise environemnts using __float128 might make
    more sense.

    Below is an example output:

    mcgrof@mouche ~/acs (git::master)$ sudo ./acs wlan0
    wlan0: remain on freq: 2412 MHz, duration: 5ms, cookie eddf9f80,
completed: yes
    wlan0: remain on freq: 2417 MHz, duration: 5ms, cookie f079d100,
completed: yes
..... etc... 10 times
    wlan0: remain on freq: 5805 MHz, duration: 5ms, cookie eddf9600,
completed: yes
    wlan0: remain on freq: 5825 MHz, duration: 5ms, cookie f08ccb00,
completed: yes
    Results for 2412 MHz: 1304446 797161 797161 759201 1014569 797161
797161 869630 797161 956593
    Results for 2417 MHz: 2207524 2207524 2207524 2575444 2207524
2575444 2277604 2207524 3311286 2575444
    Results for 2422 MHz: 408800 245280 245280 245280 245280 245280
245280 155003 327040 245280
    Results for 2427 MHz: 6622572 6622572 6622572 6622572 7726334
7726334 8830096 6622572 6622572 6622572
    Results for 2432 MHz: 19867717 23179003 23179003 19867717 23179003
19867717 23179003 19867717 19867717 29801576
    Results for 2437 MHz: 858481 735841 735841 858481 1349042 1103762
1103762 735841 735841 735841
    Results for 2442 MHz: 8830096 6622572 7726334 9933858 6622572
4304672 6622572 5466250 6622572 7726334
    Results for 2447 MHz: 1688106 2207524 2575444 2207524 2207524
3311286 2575444 2207524 2207524 2575444
    Results for 2452 MHz: 245280 245280 245280 286160 245280 245280
286160 245280 367920 202453
    Results for 2457 MHz: 245280 245280 245280 151840 245280 286160
286160 245280 327040 286160
    Results for 2462 MHz: 735841 735841 858481 735841 735841 735841
858481 656485 956593 735841
    Results for 5180 MHz: 12 12 12 12 12 12 12 12 12 12
    Results for 5200 MHz: 12 12 12 12 12 12 12 12 6 12
    Results for 5220 MHz: 37 37 37 37 37 37 37 37 37 37
    Results for 5240 MHz: 37 37 37 28 37 37 37 37 37 37
    Results for 5260 MHz: 37 37 37 37 37 37 37 37 37 37
    Results for 5280 MHz: 112 112 112 112 112 112 112 69 112 112
    Results for 5300 MHz: 37 37 37 37 37 19 37 37 37 37
    Results for 5320 MHz: 336 336 208 336 336 118 112 112 112 112
    Results for 5745 MHz: 0 0 0 0 0 0 0 0 0 0
    Results for 5765 MHz: 11 11 9 11 11 11 11 11 11 11
    Results for 5785 MHz: 4 4 4 4 4 4 4 4 4 4
    Results for 5805 MHz: 13 13 13 13 13 13 13 8 13 13
    Results for 5825 MHz: 0 0 0 0 0 0 0 0 0 0
    2412 MHz: 8890244
    2417 MHz: 24352842
    2422 MHz: 686827874236228875
    2427 MHz: 686828320980860728
    2432 MHz: 686828767808675021
    2437 MHz: 686829214272370469
    2442 MHz: 686829661010494456
    2447 MHz: 227657095576
    2452 MHz: 562984315774111
    2457 MHz: 47247335096
    2462 MHz: 16607109533019720
    5180 MHz: 120
    5200 MHz: 114
    5220 MHz: 370
    5240 MHz: 361
    5260 MHz: 370
    5280 MHz: 1077
    5300 MHz: 352
    5320 MHz: 2118
    5745 MHz: 0
    5765 MHz: 108
    5785 MHz: 40
    5805 MHz: 125
    5825 MHz: 0
    Ideal freq: 5745 MHz

    Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>

[1] http://marc.info/?t=130624150700002&r=1&w=2

  Luis
