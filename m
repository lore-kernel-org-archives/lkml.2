Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753668Ab2LZEb0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Dec 2012 23:31:26 -0500
Received: from 1.21jiggawatts.net ([173.203.126.100]:51041 "EHLO
	1.21jiggawatts.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753112Ab2LZEbZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Dec 2012 23:31:25 -0500
X-Greylist: delayed 624 seconds by postgrey-1.27 at vger.kernel.org; Tue, 25 Dec 2012 23:31:25 EST
Message-ID: <50DA7B10.9030807@1.21jiggawatts.net>
Date: Wed, 26 Dec 2012 15:20:32 +1100
From: Thomas Karpiniec <tk@1.21jiggawatts.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.11) Gecko/20121122 Icedove/10.0.11
MIME-Version: 1.0
To: alsa-devel@vger.kernel.org
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] Prevent loss of state between MIDI subscriptions
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A MIDI input parser is unnecessarily reset whenever a new subscription 
is created.

This is a particular problem with the Novation Launchpad, which sends a 
single NOTEON command, then a series of notes indefinitely unless a 
control button is pressed or it is power cycled. If a user application 
restarts and resubscribes, the parser no longer knows that it is 
receiving NOTEONs and fails to pass on new input.

Signed-off-by: Thomas Karpiniec <tk@1.21jiggawatts.net>
---
  sound/core/seq/seq_midi.c |    1 -
  1 file changed, 1 deletion(-)

diff --git a/sound/core/seq/seq_midi.c b/sound/core/seq/seq_midi.c
index 64069db..1a977df 100644
--- a/sound/core/seq/seq_midi.c
+++ b/sound/core/seq/seq_midi.c
@@ -200,7 +200,6 @@ static int midisynth_subscribe(void *private_data, 
struct snd_seq_port_subscribe
  		snd_rawmidi_kernel_release(&msynth->input_rfile);
  		return err;
  	}
-	snd_midi_event_reset_encode(msynth->parser);
  	runtime->event = snd_midi_input_event;
  	runtime->private_data = msynth;
  	snd_rawmidi_kernel_read(msynth->input_rfile.input, NULL, 0);
-- 
1.7.10.4
