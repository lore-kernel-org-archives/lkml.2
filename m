Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760081Ab0GQRVF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jul 2010 13:21:05 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:38494 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756259Ab0GQRVD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jul 2010 13:21:03 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 17 Jul 2010 19:20:51 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: PHY pinging test tool
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.506ae60f1ea3a97a@s5r6.in-berlin.de>
Message-ID: <tkrat.540ce89bb6307428@s5r6.in-berlin.de>
References: <tkrat.59dee0979cf9dbb0@s5r6.in-berlin.de>
 <tkrat.506ae60f1ea3a97a@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

/*
 * Ping packet transmission test
 *
 * Usage:
 *   - Compile with "gcc test-phy-pinging.c".
 *   - Run with "sudo ./a.out /dev/fw*".
 *   - It will print the ping time to all PHYs and exit.
 */

#include <fcntl.h>
#include <linux/firewire-cdev.h>
#include <poll.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <sys/ioctl.h>
#include <sys/stat.h>
#include <sys/types.h>

static const char *rcode_to_str(int rcode)
{
	switch (rcode) {
	case RCODE_COMPLETE:		return "complete";
	case RCODE_CONFLICT_ERROR:	return "conflict error";
	case RCODE_DATA_ERROR:		return "data error";
	case RCODE_TYPE_ERROR:		return "type error";
	case RCODE_ADDRESS_ERROR:	return "address error";
	case RCODE_SEND_ERROR:		return "send error";
	case RCODE_CANCELLED:		return "cancelled";
	case RCODE_BUSY:		return "busy";
	case RCODE_GENERATION:		return "generation";
	case RCODE_NO_ACK:		return "no ack";
	}
	return "unknown";
}

static void read_events(int fd)
{
	char buffer[sizeof(struct fw_cdev_event_phy_packet) + 4];
	struct fw_cdev_event_common *ec		= (void *)buffer;
	struct fw_cdev_event_phy_packet *epp	= (void *)buffer;
	ssize_t s = sizeof buffer;
	struct pollfd pfd = {
		.fd	= fd,
		.events	= POLLIN | POLLHUP,
	};

	while (poll(&pfd, 1, 10) > 0) {
		memset(buffer, 0, s);
		s = read(fd, buffer, sizeof buffer);
		if (s < 0) {
			fprintf(stderr, "Failed read: %m\n");
			return;
		}

		switch (ec->type) {
		case FW_CDEV_EVENT_PHY_PACKET_SENT:
			if (epp->rcode == RCODE_COMPLETE)
				printf("PING - phy_id = %d, data = %08x (%.2f us)\n",
				       (int)epp->closure,
				       epp->data[0], epp->data[0] / 49.152);
			else
				printf("PING - phy_id = %d, rcode = %s\n",
				       (int)epp->closure,
				       rcode_to_str(epp->rcode));
			break;
		}
	}
}

static void cooked_ioctl(int fd, int req, void *arg)
{
	if (ioctl(fd, req, arg) < 0)
		fprintf(stderr, "Failed ioctl '%c' 0x%02x: %m\n",
			_IOC_TYPE(req), _IOC_NR(req));
}

void test_phy_pinging(const char *filename)
{
	__u32 rom[5];
	struct fw_cdev_event_bus_reset reset;
	struct fw_cdev_get_info info = {
		.version	= 4,
		.rom		= (unsigned long)rom,
		.rom_length	= sizeof(rom),
		.bus_reset	= (unsigned long)&reset,
	};
	struct fw_cdev_send_phy_packet p;
	int fd, ln, nn, i;

	fd = open(filename, O_RDWR);
	if (fd < 0) {
		fprintf(stderr, "Failed to open %s: %m\n", filename);
		goto out;
	}

	cooked_ioctl(fd, FW_CDEV_IOC_GET_INFO, &info);
	if (reset.node_id != reset.local_node_id) {
		fprintf(stderr, "%s: Not a local node\n", filename);
		goto out_fd;
	}

	p.generation = reset.generation;
	ln = reset.local_node_id & 63;
	nn = (reset.root_node_id & 63) + 1;

	printf("%s: card %d, generation %d, %d nodes, "
	       "local phy_id %d, EUI-64 %08x%08x\n",
	       filename, info.card, reset.generation,
	       nn, ln, rom[3], rom[4]);

	for (i = 0; i < nn; i++) {
		p.closure = i;
		p.data[0] = i << 24;
		p.data[1] = ~p.data[0];
		cooked_ioctl(fd, FW_CDEV_IOC_SEND_PHY_PACKET, &p);
	}

	read_events(fd);
out_fd:
	close(fd);
out:
	printf("\n");
}

int main(int argc, char **argv)
{
	int i;

	if (argc < 2) {
		fprintf(stderr, "Usage: %s /dev/fwX [/dev/fwY ...]\n", argv[0]);
		return 1;
	}

	for (i = 1; i < argc; i++)
		test_phy_pinging(argv[i]);

	return 0;
}


