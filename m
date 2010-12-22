Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752618Ab0LVOHk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 09:07:40 -0500
Received: from smtp.df.ru ([195.42.160.16]:35770 "EHLO smtp.df.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751900Ab0LVOHj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 09:07:39 -0500
X-Greylist: delayed 1280 seconds by postgrey-1.27 at vger.kernel.org; Wed, 22 Dec 2010 09:07:39 EST
Date: Wed, 22 Dec 2010 16:43:43 +0300
From: Alexey Vlasov <renton@renton.name>
To: linux-kernel@vger.kernel.org
Subject: 2.6.36.2 - loop on read /proc/net/tcp
Message-ID: <20101222134343.GC19998@beaver.vrungel.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

Has anyone seen such a bug at 2.6.36.2?
# netstat -ntl
Active Internet connections (only servers)
Proto Recv-Q Send-Q Local Address           Foreign Address         State
tcp        0      0 81.176.228.2:60608      0.0.0.0:*               LISTEN
tcp        0      0 81.176.228.4:8099       0.0.0.0:*               LISTEN
tcp        0      0 81.176.228.5:8099       0.0.0.0:*               LISTEN
tcp        0      0 81.176.228.7:8099       0.0.0.0:*               LISTEN
tcp        0      0 81.176.228.4:8100       0.0.0.0:*               LISTEN
tcp        0      0 81.176.228.5:8100       0.0.0.0:*               LISTEN
tcp        0      0 81.176.228.4:8101       0.0.0.0:*               LISTEN
tcp        0      0 81.176.228.5:8101       0.0.0.0:*               LISTEN
tcp        0      0 81.176.228.5:20037      0.0.0.0:*               LISTEN
tcp        0      0 81.176.228.4:8102       0.0.0.0:*               LISTEN
tcp        0      0 81.176.228.5:8102       0.0.0.0:*               LISTEN
tcp        0      0 127.0.0.1:3399          0.0.0.0:*               LISTEN
tcp        0      0 81.176.228.4:20040      0.0.0.0:*               LISTEN
tcp        0      0 81.176.228.4:38985      0.0.0.0:*               LISTEN
tcp        0      0 0.0.0.0:873             0.0.0.0:*               LISTEN
tcp        0      0 81.176.228.4:20041      0.0.0.0:*               LISTEN
tcp        0      0 81.176.228.4:20042      0.0.0.0:*               LISTEN
tcp        0      0 81.176.228.4:3306       0.0.0.0:*               LISTEN
tcp        0      0 81.176.228.3:3306       0.0.0.0:*               LISTEN
tcp        0      0 81.176.228.2:3306       0.0.0.0:*               LISTEN
tcp        0      0 81.176.228.5:9099       0.0.0.0:*               LISTEN
tcp        0      0 81.176.228.4:9099       0.0.0.0:*               LISTEN
tcp        0      0 81.176.228.4:20043      0.0.0.0:*               LISTEN
tcp        0      0 0.0.0.0:139             0.0.0.0:*               LISTEN
tcp        0      0 81.176.228.5:9100       0.0.0.0:*               LISTEN
tcp        0      0 81.176.228.4:9100       0.0.0.0:*               LISTEN
tcp        0      0 81.176.228.4:20044      0.0.0.0:*               LISTEN
tcp        0      0 81.176.228.5:33549      0.0.0.0:*               LISTEN
...
First 30 lines are ok

but then go lines repeating in "eternal" loop:
tcp        0      0 81.176.228.2:80         0.0.0.0:*               LISTEN
tcp        0      0 81.176.228.3:80         0.0.0.0:*               LISTEN
tcp        0      0 81.176.228.4:80         0.0.0.0:*               LISTEN
tcp        0      0 81.176.228.7:80         0.0.0.0:*               LISTEN
tcp        0      0 81.176.228.2:80         0.0.0.0:*               LISTEN
tcp        0      0 81.176.228.3:80         0.0.0.0:*               LISTEN
tcp        0      0 81.176.228.4:80         0.0.0.0:*               LISTEN
tcp        0      0 81.176.228.7:80         0.0.0.0:*               LISTEN
tcp        0      0 81.176.228.2:80         0.0.0.0:*               LISTEN
tcp        0      0 81.176.228.3:80         0.0.0.0:*               LISTEN
tcp        0      0 81.176.228.4:80         0.0.0.0:*               LISTEN
tcp        0      0 81.176.228.7:80         0.0.0.0:*               LISTEN
tcp        0      0 81.176.228.2:80         0.0.0.0:*               LISTEN

# cat /proc/net/tcp
...
It can hang an hour or so. but not always actually.

# i=0; while [ "$i" -lt "10" ]; do time wc -l /proc/net/tcp; let "i = $i + 1"; done
614782727 /proc/net/tcp

real    18m42.066s
user    0m12.620s
sys     18m25.890s
19443 /proc/net/tcp

real    0m0.040s
user    0m0.000s
sys     0m0.030s
19503 /proc/net/tcp

real    0m0.040s
sys     0m0.030s
19502 /proc/net/tcp

real    0m0.041s
user    0m0.000s
sys     0m0.040s
28525 /proc/net/tcp

real    0m0.059s
user    0m0.000s
sys     0m0.050s
19463 /proc/net/tcp

real    0m0.048s
user    0m0.000s
sys     0m0.040s
19521 /proc/net/tcp

real    0m0.040s
user    0m0.000s
sys     0m0.030s
54394 /proc/net/tcp

real    0m0.104s
user    0m0.000s
sys     0m0.100s
19479 /proc/net/tcp

real    0m0.040s
user    0m0.000s
sys     0m0.030s
19481 /proc/net/tcp

real    0m0.040s
user    0m0.000s
sys     0m0.030s

-- 
BRGDS. Alexey Vlasov.
